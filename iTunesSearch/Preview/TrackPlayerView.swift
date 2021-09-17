//
//  PreviewViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.08.2021.
//

import UIKit

protocol PreviewAudioDelegate: AnyObject {
	func playerBeginDownloadSong()
	func playerCancelDownloadSong()
	func playerBeginPlay()
	func playerStopPlay()
	func playerUpdateData(string: String, float: Float)
	func error()
}

final class TrackPlayerView: UIView {
	private lazy var trackInfoLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "Загрузить фрагмент"
		label.font = DefaultStyle.Fonts.system19
		label.textColor = DefaultStyle.Colors.white
		return label
	}()

	private lazy var progressView: UIProgressView = {
		let progress = UIProgressView(frame: .zero)
		progress.progressViewStyle = .bar
		progress.progressTintColor = DefaultStyle.Colors.red
		progress.trackTintColor = DefaultStyle.Colors.white
		progress.progress = 0.0
		return progress
	}()

	private lazy var playerButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(.download)
		return button
	}()

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	public func setupButton(_ target: Any?, action: Selector) {
		playerButton.addTarget(target, action: action, for: [.touchUpInside])
	}

	private func setupView() {
		borderWithRadius(color: DefaultStyle.Colors.borderColor, width: 2.0, radius: 10.0)
		backgroundColor = DefaultStyle.Colors.redBackground
		addSubview(playerButton)
		addSubview(trackInfoLabel)
		addSubview(progressView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerButton.frame = CGRect(x: 10, y: (frame.height - 48) / 2, width: 48, height: 48)
		trackInfoLabel.frame = CGRect(x: 83, y: 11, width: frame.width - 92, height: 20)
		progressView.frame = CGRect(x: 83, y: frame.height - 14, width: frame.width - 92, height: 2)
	}
}

// MARK: - PreviewAudioDelegate

extension TrackPlayerView: PreviewAudioDelegate {
	func playerCancelDownloadSong() {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = "Загрузить фрагмент"
			self?.playerButton.stopRotating()
			self?.progressView.progress = 0.0
		}
	}

	func error() {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = "Error"
		}
	}

	func playerBeginDownloadSong() {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = "Загрузка фрагмента"
			self?.playerButton.rotate(duration: 1)
		}
	}

	func playerBeginPlay() {
		DispatchQueue.main.async { [weak self] in
			self?.playerButton.setImage(.pause)
			self?.playerButton.pulsate()
		}
	}

	func playerStopPlay() {
		DispatchQueue.main.async { [weak self] in
			self?.playerButton.setImage(.play)
			self?.playerButton.stopRotating()
			self?.playerButton.pulsate()
		}
	}

	func playerUpdateData(string: String, float: Float) {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = string
			self?.progressView.progress = float
		}
	}
}
