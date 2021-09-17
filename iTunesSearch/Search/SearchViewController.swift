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
	let adapter: CollectionAdapter

	init(viewModel: SearchViewModel, adapter: CollectionAdapter) {
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
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = DefaultStyle.Colors.background
		return collectionView
	}()

	private lazy var сounter: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system15
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

		adapter.willDisplayItem = { [weak viewModel] index in
			viewModel?.checkIsLastItem(index)
		}

		adapter.onSelectItem = { [weak viewModel] index in
			viewModel?.toPreview(index)
		}

		viewModel.searchBegin = { [weak сounter] in
			сounter?.searching()
		}

		viewModel.searchComplete = { [weak self] array in
			self?.adapter.insertItems(array)
			self?.сounter.update(array?.count)
		}

		viewModel.showMessage = { [weak self] isError, message in
			Toast.show(message: message, controller: self!, isError: isError)
			self?.adapter.insertItems(nil)
			self?.сounter.update()
		}

		viewModel.start()
	}

	private func setupView() {
		title = "iTunesSearch"
		adapter.setup(collectionView: collectionView)

		view.addSubview(collectionView)
		view.addSubview(сounter)

		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false

		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),

			сounter.widthAnchor.constraint(equalToConstant: 60),
			сounter.heightAnchor.constraint(equalToConstant: 40),
			сounter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
			сounter.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
		])
	}
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		viewModel.search(text)
	}
}

extension UILabel {
	fileprivate func update(_ count: Int? = 0) {
		DispatchQueue.main.async { [weak self] in
			self?.text = String(count ?? 0)
			self?.textColor = count == 0 ? .clear : .darkGray
		}
	}

	fileprivate func searching() {
		DispatchQueue.main.async { [weak self] in
			self?.text = "!"
			self?.textColor = .darkGray
		}
	}
}
