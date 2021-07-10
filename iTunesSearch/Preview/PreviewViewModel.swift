//
//  PreviewViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

protocol PreviewViewModel {
	func start(updateImage: @escaping (UIImage) -> Void)
	func update()
	var item: iTunesItem { get }
}

class PreviewViewModelImpl: PreviewViewModel {
	private let imageService: ImageService
	private let router: Router
	public var item: iTunesItem
	private var updateImage: (UIImage) -> Void = { _ in }

	init(router: Router, imageService: ImageService, item: iTunesItem) {
		self.router = router
		self.imageService = imageService
		self.item = item
        print(item)
	}

	func start(
		updateImage: @escaping (UIImage) -> Void
	) {
		self.updateImage = updateImage
	}

	public func update() {
		//  self.presenter.updateView(previewItem)
		//        self.previewAudio = PreviewAudio(url: item.previewUrl, delegate: player!)

		// Загрузка из кэша маленькой картинки

		func updateView(image: UIImage) {
			DispatchQueue.main.async { [weak self] in
				self?.updateImage(image)
			}
		}

		guard let url100 = item.artworkUrl100 else { return }
		imageService.download(path: url100) { image, _ in
			updateView(image: image)
		}
		// Загрузка большой картинки
		imageService.download(path: item.artworkUrl600) { image, _ in
			updateView(image: image)
		}
	}
}
