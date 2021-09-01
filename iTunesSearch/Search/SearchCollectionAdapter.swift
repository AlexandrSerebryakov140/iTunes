//
//  CollectionViewAdapter.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 06.08.2021.
//

import Foundation
import UIKit

final class SearchCollectionAdapter: NSObject {
	private weak var collectionView: UICollectionView?
	private weak var viewModel: SearchViewModel?
	private let imageService: ImageService
	private var items: [SearchCellModel] = []
	private let reuseIdentifier = "Cell"
	private var noArtworkImage = UIImage(.noArtwork)

	init(viewModel: SearchViewModel, imageService: ImageService) {
		self.viewModel = viewModel
		self.imageService = imageService
	}

	public func setup(collectionView: UICollectionView) {
		self.collectionView = collectionView
		self.collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView?.backgroundColor = DefaultStyle.Colors.background
		self.collectionView?.keyboardDismissMode = .onDrag
		self.collectionView?.translatesAutoresizingMaskIntoConstraints = false

		self.collectionView?.delegate = self
		self.collectionView?.dataSource = self
	}

	public var count: Int {
		items.count
	}

	public func insertItems(_ itemsList: [SearchCellModel]?) {
		guard let list = itemsList else {
			items = []
			reload()
			return
		}

		let updateItems = updateItemsList(list: list)
		items.append(contentsOf: list)

		if updateItems.first?.row ?? 0 > 0 {
			reloadWithInsertItems(updateItems: updateItems)
		} else {
			reload()
		}
	}

	private func reload() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView?.reloadData()
		}
	}

	private func reloadWithInsertItems(updateItems: [IndexPath]) {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView?.performBatchUpdates({ [weak self] in
				self?.collectionView?.insertItems(at: updateItems)
			}, completion: { _ in })
		}
	}

	private func updateItemsList(list: [Any]) -> [IndexPath] {
		let first = items.count
		let second = items.count + list.count - 1

		var array: [IndexPath] = []

		for index in first ... second {
			let indexPath = IndexPath(row: index, section: 0)
			array.append(indexPath)
		}

		return array
	}
}

extension SearchCollectionAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
		CGSize(width: collectionView.frame.size.width, height: SearchCell.height())
	}

	func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		items.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
		let cellModel = items[indexPath.row]
		let noImage: UIImage = noArtworkImage.copy() as! UIImage
		cell.configureCell(cellModel, noArtworkImage: noImage)
		loadImage(artworkUrl: cellModel.artworkUrl) { [weak cell] image, path in
			cell?.setupImage(image: image, path: path)
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.cellForItem(at: indexPath)?.isSelected = true
		viewModel?.toPreview(indexPath.row)
	}

	func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		viewModel?.checkIsLastItem(indexPath.row)
	}

	public func loadImage(artworkUrl: String?, completion: @escaping (UIImage, String) -> Void) {
		imageService.download(path: artworkUrl) { image, path in
			completion(image, path)
		}
	}
}
