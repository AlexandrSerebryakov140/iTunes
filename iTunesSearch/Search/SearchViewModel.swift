//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

protocol SearchViewModel {
	func start(reload: @escaping () -> Void, showMessage: @escaping (String) -> Void)
	func search(_ text: String)
	func checkLast(_ index: Int)
	func count() -> Int
	func model(_ index: Int) -> SearchCellModel
	func loadImage(index: Int, completion: @escaping (UIImage) -> Void)
	var noArtworkImage: UIImage { get }
	func toPreview(_ index: Int)
}

class SearchViewModelImpl: SearchViewModel {
	private let searchService: SearchService
	private let imageService: ImageService
	private let router: Router
	private var reload: () -> Void = {}
	private var showMessage: (String) -> Void = { _ in }
	private var items: [iTunesItem] = []
	private var lastSearch = ""
	private var isUpdate = false

	init(router: Router, searchService: SearchService, imageService: ImageService) {
		self.router = router
		self.searchService = searchService
		self.imageService = imageService
	}

	public func start(
		reload: @escaping () -> Void,
		showMessage: @escaping (String) -> Void
	) {
		self.reload = reload
		self.showMessage = showMessage
		search("")
	}

	public func count() -> Int {
		items.count
	}

	public func model(_ index: Int) -> SearchCellModel {
		let item = items[index]
		return SearchCellModel(item)
	}

	private func createList(list: iTunesList, request: String) {
		Logger.log(state: .info, message: "По запросу '\(request)' получено \(list.results.count) треков")

		self.items = []
		lastSearch = request
		list.results.forEach { [weak self] item in
			self?.items.append(item)
		}
		reload()
	}

	private func updateList(list: iTunesList) {
		Logger.log(state: .info, message: "Добавлено ещё \(list.results.count) треков")

		list.results.forEach { [weak self] item in
			self?.items.append(item)
		}
		reload()
	}

	public func search(_ text: String) {
		if text.isEmpty {
			items = []
			showMessage("Введите ключевые слова в строке поиска")
			return
		}
		if text.count < 5 {
			items = []
			showMessage("В запросе должно быть не менее 5 символов")
			return
		}

		self.searchService.beginSearch(search: text, offset: 0, completion: { [weak self] result in
			switch result {
			case let .success(list):
				self?.createList(list: list, request: text)
			case let .failure(error):
				self?.items = []
				self?.showMessage(error.text())
			}
		})
	}

	public func checkLast(_ index: Int) {
		guard index >= items.count - 1 else { return }
		guard !isUpdate else { return }

		isUpdate = true

		searchService.beginSearch(search: lastSearch, offset: items.count, completion: { [weak self] result in
			switch result {
			case let .success(list):
				self?.updateList(list: list)
			case let .failure(error):
				Logger.log(state: .error, message: error.text())
			}
			self?.isUpdate = false
		})
	}

	public var noArtworkImage = UIImage(named: "noArtwork")!

	public func loadImage(index: Int, completion: @escaping (UIImage) -> Void) {
		let path = items[index].artworkUrl100
		imageService.download(path: path) { [weak self] image, newPath in
			guard index <= self?.items.count ?? 1 - 1 else { return }
			guard newPath == self?.items[index].artworkUrl100 else { return }
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}

	public func toPreview(_ index: Int) {
		let item = items[index]
		router.toPreview(item: item)
	}
}
