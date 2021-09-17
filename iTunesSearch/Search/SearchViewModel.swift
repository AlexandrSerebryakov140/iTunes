//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

protocol SearchViewModel: AnyObject {
	var searchBegin: () -> Void { get set }
	var searchComplete: ([SearchCellModel]?) -> Void { get set }
	var showMessage: (Bool, String) -> Void { get set }
	var count: Int { get }

	func start()
	func search(_ text: String)
	func checkIsLastItem(_ index: Int)
	func toPreview(_ index: Int)
}

class SearchViewModelImpl: SearchViewModel {
	public var searchBegin: () -> Void = {}
	public var searchComplete: ([SearchCellModel]?) -> Void = { _ in }
	public var showMessage: (Bool, String) -> Void = { _, _ in }

	private let searchService: SearchService
	private let router: Router
	private var items: [iTunesItem] = []
	private var lastSearch = ""
	private var isUpdate = false

	init(router: Router, searchService: SearchService) {
		self.router = router
		self.searchService = searchService
	}

	public func start() {
		search("")
	}

	public func search(_ text: String) {
		if text.isEmpty {
			clearList()
			showMessage(false, "Введите ключевые слова в строке поиска")
			return
		}

		if lastSearch == text { return }

		if text.count < 5 {
			clearList()
			showMessage(false, "В запросе должно быть не менее 5 символов")
			return
		}

		searchBegin()

		searchService.beginSearch(search: text, offset: 0, completion: { [weak self] result in
			switch result {
			case let .success(list):
				self?.createList(list: list, request: text)
			case let .failure(error):
				self?.clearList()
				self?.showMessage(true, error.text())
			}
		})
	}

	public var count: Int {
		items.count
	}

	public func checkIsLastItem(_ index: Int) {
		guard index >= items.count - 2 else { return }
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

	public func toPreview(_ index: Int) {
		let item = items[index]
		router.toPreview(item: item)
	}

	// MARK: - Работа со списком

	private func createList(list: iTunesList, request: String) {
		Logger.log(state: .info, message: "По запросу '\(request)' получено \(list.results.count) треков")

		clearList()
		lastSearch = request
		items.append(contentsOf: list.results)
		searchComplete(list.results.map { $0.toCellModel() })
	}

	private func updateList(list: iTunesList) {
		Logger.log(state: .info, message: "Добавлено ещё \(list.results.count) треков")

		items.append(contentsOf: list.results)
		searchComplete(list.results.map { $0.toCellModel() })
	}

	private func clearList() {
		items = []
		lastSearch = ""
		searchComplete(nil)
	}
}
