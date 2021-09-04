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

	private lazy var searchCounter: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system18
		label.numberOfLines = 1
		label.textAlignment = .center
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()

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
		setupView()

		viewModel.searchBegin = { [weak self] in
			self?.searching()
		}

		viewModel.searchComplete = { [weak self] array in
			self?.adapter.insertItems(array)
			self?.update()
		}

		viewModel.showMessage = { [weak self] isError, message in
			Toast.show(message: message, controller: self!, isError: isError)
			self?.adapter.insertItems(nil)
			self?.update()
		}

		viewModel.start()
	}

	private func setupView() {
		title = "iTunesSearch"
		adapter.setup(collectionView: collectionView)

		view.addSubview(collectionView)
		view.addSubview(searchCounter)

		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false

		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),

			searchCounter.widthAnchor.constraint(equalToConstant: 60),
			searchCounter.heightAnchor.constraint(equalToConstant: 40),
			searchCounter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
			searchCounter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
		])
	}

	private func update() {
		DispatchQueue.main.async { [weak self] in
			let count = self?.adapter.count ?? 0
			self?.searchCounter.text = String(count)
			self?.searchCounter.textColor = count == 0 ? .clear : .darkGray
		}
	}

	private func searching() {
		DispatchQueue.main.async { [weak self] in
			self?.searchCounter.text = "!"
			self?.searchCounter.textColor = .darkGray
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
