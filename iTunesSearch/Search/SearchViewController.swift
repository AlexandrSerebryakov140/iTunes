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

	init(viewModel: SearchViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let reuseIdentifier = "Cell"

	private lazy var collectionView: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.keyboardDismissMode = .onDrag
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
		view.addSubview(collectionView)
		view.addSubview(searchCounter)

		navigationItem.searchController = search
		navigationItem.hidesSearchBarWhenScrolling = false

		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
		])

		viewModel.start(reload: { [unowned self] in
			self.update()
		}, showMessage: { [unowned self] message in
			self.update()
			SearchToast.show(message: message, controller: self)
		})
		searchCounter.update(value: viewModel.count())
	}

	private func update() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView.reloadData()
			if let count = self?.viewModel.count() {
				self?.searchCounter.update(value: count)
			}
		}
	}
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
		CGSize(width: collectionView.frame.size.width, height: SearchCell.height())
	}

	func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		viewModel.count()
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
		let model = viewModel.model(indexPath.row)
		cell.configureCell(model)
		cell.artwork.image = viewModel.noArtworkImage
		viewModel.loadImage(index: indexPath.row) { [weak cell] image in
			cell?.artwork.image = image
			cell?.layoutIfNeeded()
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.cellForItem(at: indexPath)?.isSelected = true
		viewModel.toPreview(indexPath.row)
	}

	func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		viewModel.checkLast(indexPath.row)
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
