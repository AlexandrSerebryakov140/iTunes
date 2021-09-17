//
//  CollectionViewAdapter.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 06.08.2021.
//

import Foundation
import UIKit

protocol CollectionAdapter: AnyObject {
	var onSelectItem: (Int) -> Void { get set }
	var willDisplayItem: (Int) -> Void { get set }
	func setup(collectionView: UICollectionView)
	func insertItems(_ itemsList: [SearchCellModel]?)
}

final class SearchCollectionAdapter: NSObject, CollectionAdapter {
	public var onSelectItem: (Int) -> Void = { _ in }
	public var willDisplayItem: (Int) -> Void = { _ in }
	private var items: [SearchCellModel] = []

	private weak var collectionView: UICollectionView?
	private let imageService: ImageService
	private let reuseIdentifier = "Cell"
	private lazy var noArtworkImage = UIImage(.noArtwork)

	init(imageService: ImageService) {
		self.imageService = imageService
	}

	public func setup(collectionView: UICollectionView) {
		self.collectionView = collectionView
		self.collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView?.delegate = self
		self.collectionView?.dataSource = self
		self.collectionView?.keyboardDismissMode = .onDrag
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
		cell.configureCell(cellModel)
		cell.configureCellImage(noArtworkImage)

		imageService.download(path: cellModel.artworkUrl) { [weak cell] image, path in
			if cell == nil { return }
			if cell?.artworkUrl != path { return }
			cell?.configureCellImage(image)
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.cellForItem(at: indexPath)?.isSelected = true
		onSelectItem(indexPath.row)
	}

	func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		willDisplayItem(indexPath.row)
	}
}
