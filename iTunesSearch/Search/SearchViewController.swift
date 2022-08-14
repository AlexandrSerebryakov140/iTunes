//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import UIKit

final class SearchViewController: UIViewController {
	let viewModel: SearchViewModel
	let adapter: CollectionAdapter

	override func loadView() {
		view = SearchView(frame: .zero)
	}

	init(viewModel: SearchViewModel, adapter: CollectionAdapter) {
		self.viewModel = viewModel
		self.adapter = adapter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupModel()
		viewModel.start()
	}

	private func setupView() {
		title = "iTunesSearch"
		let search: UISearchController = {
			let search = UISearchController(searchResultsController: nil)
			search.searchResultsUpdater = self
			search.obscuresBackgroundDuringPresentation = false
			search.searchBar.placeholder = "Введите ключевое слово для поиска"
			search.searchBar.delegate = self
			return search
		}()

		if let searchView = view as? SearchView {
			adapter.setup(collectionView: searchView.collectionView)
			navigationItem.searchController = search
			navigationItem.hidesSearchBarWhenScrolling = false
		}
	}

	private func setupModel() {
		let searchView = view as! SearchView

		adapter.willDisplayItem = { [weak viewModel] index in
			guard let model = viewModel, model.checkForUpdate(index) else { return }
			model.update()
		}

		adapter.onSelectItem = { [weak viewModel] index in
			viewModel?.toPreview(index)
		}

		viewModel.searchBegin = {
			searchView.counterSearching()
		}

		viewModel.searchComplete = { [weak self, searchView] array, count in
			self?.adapter.insertItems(array.map { $0.toCellModel() })
			searchView.counterUpdate(count)
		}

		viewModel.searchClear = { [weak self] in
			self?.adapter.clearItems()
			searchView.counterUpdate(0)
		}

		viewModel.showMessage = { [weak self, searchView] isError, message in
			Toast.show(message: message, controller: self!, isError: isError)
			self?.adapter.clearItems()
			searchView.counterUpdate()
		}
	}
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		if viewModel.checkForSearch(text) {
			viewModel.search(text)
		}
	}
}
