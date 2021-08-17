//
//  SearchViewController.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController {
	let viewModel: SearchViewModel
	let adapter: SearchCollectionAdapter

	init(viewModel: SearchViewModel, adapter: SearchCollectionAdapter) {
		self.viewModel = viewModel
		self.adapter = adapter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private lazy var collectionView: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		return collectionView
	}()

	private lazy var searchCounter = SearchCounterLabel(viewModel: viewModel)

	private lazy var search: UISearchController = {
		let search = UISearchController(searchResultsController: nil)
		search.searchResultsUpdater = self
		search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Введите ключевое слово для поиска"
		search.searchBar.delegate = self
		return search
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "iTunesSearch"
		adapter.setup(collectionView: collectionView)
		adapter.subview(view: view)

		view.addSubview(searchCounter)

		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false

		viewModel.start()

		viewModel.searchBegin = { [weak self] in
			self?.searchCounter.searching()
		}

		viewModel.searchComplete = { [weak self] array in
			self?.adapter.insertItems(itemsList: array)
			self?.searchCounter.update(count: self?.adapter.count ?? 0)
		}

		viewModel.showMessage = { [weak self] message in
			SearchToast.show(message: message, controller: self!)
			self?.adapter.reload()
			self?.searchCounter.update(count: self?.adapter.count ?? 0)
		}
	}
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		viewModel.search(text)
	}
}
