//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import UIKit

class SearchViewModelImpl: SearchViewModel {
	public var searchBegin: () -> Void = {}
	public var searchComplete: ([iTunesItem], Int) -> Void = { _, _ in }
	public var searchClear: () -> Void = {}

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
		clearList()
		showMessage(false, "Введите ключевые слова в строке поиска")
	}

	// MARK: - Search

	public func checkForSearch(_ text: String) -> Bool {
		if text.isEmpty {
			clearList()
			showMessage(false, "Введите ключевые слова в строке поиска")
			return false
		}

		if lastSearch == text {
			return false
		}

		if text.count < 5 {
			clearList()
			showMessage(false, "В запросе должно быть не менее 5 символов")
			return false
		}

		return true
	}

	public func search(_ text: String) {
		searchBegin()

		searchService.search(search: text, offset: 0, completion: { [weak self] result in
			self?.searchResult(result: result, text: text)
		})
	}

	// MARK: - Update

	public func checkForUpdate(_ index: Int) -> Bool {
		if index <= items.count - 2 { return false }
		if isUpdate { return false }
		return true
	}

	public func update() {
		isUpdate = true

		searchService.search(search: lastSearch, offset: items.count, completion: { [weak self] result in
			self?.updateResult(result: result)
			self?.isUpdate = false
		})
	}

	// MARK: - Result

	private func searchResult(result: SearchResult, text: String) {
		if case let .success(list) = result {
			Logger.log(state: .info, message: "По запросу '\(text)' получено \(list.results.count) треков")
			clearList()
			lastSearch = text
			items.append(contentsOf: list.results)
			searchComplete(list.results, items.count)
		} else if case let .failure(error) = result {
			Logger.log(state: .error, message: error.text())
			showMessage(true, error.text())
			clearList()
		}
	}

	private func updateResult(result: SearchResult) {
		switch result {
		case let .success(list):
			Logger.log(state: .info, message: "Добавлено ещё \(list.results.count) треков")
			items.append(contentsOf: list.results)
			searchComplete(list.results, items.count)
		case let .failure(error):
			Logger.log(state: .error, message: error.text())
			showMessage(true, error.text())
		}
	}

	private func clearList() {
		items = []
		lastSearch = ""
		searchClear()
	}

	// MARK: - Go to Preview

	public func toPreview(_ index: Int) {
		let item = items[index]
		router.toPreview(item: item)
	}
}
