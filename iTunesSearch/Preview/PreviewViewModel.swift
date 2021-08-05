//
//  PreviewViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

enum TrackPlayerState: String {
	case none // исходное состояние
	case trackIsDownloaded // фрагмент трека загружается
	case trackStop // трек загружен но остановлен
	case trackPlay // трек играется
	case error // ошибка
}

protocol PreviewViewModel {
	func start(_ updateImage: @escaping (UIImage) -> Void)
	func update(_ audioDelegate: PreviewAudioDelegate)
	func didTapButton()
	var item: iTunesItem { get }
}

class PreviewViewModelImpl: PreviewViewModel {
	private let imageService: ImageService
	private let router: Router
	public var item: iTunesItem
	private var previewAudio: TrackPreviewAudio?
	private var updateImage: (UIImage) -> Void = { _ in }
	private let downloader = TrackDownloader()
	private weak var delegate: PreviewAudioDelegate?
	private var state: TrackPlayerState = .none

	init(router: Router, imageService: ImageService, item: iTunesItem) {
		self.router = router
		self.imageService = imageService
		self.item = item
//		print(item)
	}

	func start(
		_ updateImage: @escaping (UIImage) -> Void
	) {
		self.updateImage = updateImage
	}

	private func updateView(image: UIImage) {
		DispatchQueue.main.async { [weak self] in
			self?.updateImage(image)
		}
	}

	public func update(_ audioDelegate: PreviewAudioDelegate) {
		previewAudio = TrackPreviewAudio()
		previewAudio?.updateState = { [weak self] state in
			self?.state = state
			self?.stateIsUpdate(state: state)
		}

		previewAudio?.updateTime = { [weak self] string, float in
			self?.delegate?.playerUpdateData(string: string, float: float)
		}

		// Загрузка из кэша маленькой картинки
		guard let url100 = item.artworkUrl100 else { return }
		imageService.download(path: url100) { [weak self] image, _ in
			self?.updateView(image: image)
		}
		// Загрузка большой картинки
		imageService.download(path: item.artworkUrl600) { [weak self] image, _ in
			self?.updateView(image: image)
		}

		delegate = audioDelegate
	}

	private func stateIsUpdate(state: TrackPlayerState) {
		switch state {
		case .trackStop:
			delegate?.playerStopPlay()
		case .trackPlay:
			delegate?.playerBeginPlay()
		case .error:
			delegate?.error()
		default:
			break
		}
	}

	public func didTapButton() {
		switch state {
		case .none:
			trackBeginDownload()
		case .trackStop:
			previewAudio?.beginPlay()
		case .trackPlay:
			previewAudio?.stopPlay()
		case .trackIsDownloaded:
			break
		case .error:
			break
		}
	}

	// MARK: - Загрузка фрагмента трека

	private func trackBeginDownload() {
		guard let previewUrl = item.previewUrl else { return }

		delegate?.playerBeginDownloadSong()
		state = .trackIsDownloaded

		downloader.progressUpdate = { [weak self] written, expected in
			self?.trackDownloadProgress(written: written, expected: expected)
		}

		downloader.completionHandler = { [weak self] result in
			self?.tackDownloadComplete(result: result)
		}

		downloader.download(previewURL: previewUrl)
	}

	private func tackDownloadComplete(result: Result<URL, FileDownloadError>) {
		switch result {
		case let .success(url):
			previewAudio?.startAudioPlayer(url)
		case let .failure(error):
			let err = String(describing: error.localizedDescription)
			delegate?.playerUpdateData(string: "Error: \(err))", float: 0)
		}
	}

	private func trackDownloadProgress(written: Int64, expected: Int64) {
		let float = Float(written) / Float(expected)
		let str = "Всего: \(String(written / 1_000)) Кб / \(String(expected / 1_000)) Кб"
		delegate?.playerUpdateData(string: str, float: float)
	}
}
