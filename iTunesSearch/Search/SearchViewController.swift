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
	let adapter: SearchCollectionViewAdapter

	init(viewModel: SearchViewModel, adapter: SearchCollectionViewAdapter) {
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

	private lazy var searchCounter = SearchCounterLabel(frame: .zero)

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

		viewModel.showMessage = { [weak self] message in
			self?.adapter.reload()
			SearchToast.show(message: message, controller: self!)
			guard let count = self?.viewModel.count else { return }
			self?.searchCounter.update(value: count)
		}

		viewModel.animatedReload = { [weak self] array in
			self?.adapter.insertItems(at: array)
			guard let count = self?.viewModel.count else { return }
			self?.searchCounter.update(value: count)
		}
	}
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		searchCounter.searching()
		viewModel.search(text)
	}
}
