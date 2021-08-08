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
	var searchComplete: ([IndexPath]) -> Void { get set }
	var showMessage: (String) -> Void { get set }

	func start()
	func search(_ text: String)
	func checkLast(_ index: Int)
	func model(_ index: Int) -> SearchCellModel
	func toPreview(_ index: Int)

	var count: Int { get }
}

class SearchViewModelImpl: SearchViewModel {
	public var searchBegin: () -> Void = {}
	public var searchComplete: ([IndexPath]) -> Void = { _ in }
	public var showMessage: (String) -> Void = { _ in }

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

	public var count: Int {
		items.count
	}

	public func model(_ index: Int) -> SearchCellModel {
		let item = items[index]
		return SearchCellModel(item)
	}

	private func updateItemsList(list: iTunesList) -> [IndexPath] {
		let first = items.count
		let second = items.count + list.results.count - 1

		var array: [IndexPath] = []

		for index in first ... second {
			let indexPath = IndexPath(row: index, section: 0)
			array.append(indexPath)
		}

		return array
	}

	private func addItems(list: iTunesList) {
		let updateItems = updateItemsList(list: list)

		list.results.forEach { [weak self] item in
			self?.items.append(item)
		}

		searchComplete(updateItems)
	}

	private func createList(list: iTunesList, request: String) {
		Logger.log(state: .info, message: "По запросу '\(request)' получено \(list.results.count) треков")

		items = []
		lastSearch = request
		addItems(list: list)
	}

	private func updateList(list: iTunesList) {
		Logger.log(state: .info, message: "Добавлено ещё \(list.results.count) треков")
		addItems(list: list)
	}

	public func search(_ text: String) {
		if lastSearch == text { return }

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

		searchBegin()

		searchService.beginSearch(search: text, offset: 0, completion: { [weak self] result in
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

	public func toPreview(_ index: Int) {
		let item = items[index]
		router.toPreview(item: item)
	}
}
