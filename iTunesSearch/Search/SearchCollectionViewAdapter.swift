//
//  CollectionViewAdapter.swift
//  iTunesSearch
//
//  Created by Alexandr on 06.08.2021.
//

import Foundation
import UIKit

class SearchCollectionViewAdapter: NSObject {
	private weak var collectionView: UICollectionView?
	private weak var viewModel: SearchViewModel?
	private let imageService: ImageService

	init(viewModel: SearchViewModel, imageService: ImageService) {
		self.viewModel = viewModel
		self.imageService = imageService
	}

	public func setup(collectionView: UICollectionView) {
		self.collectionView = collectionView
		self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
		self.collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView?.backgroundColor = .white
		self.collectionView?.keyboardDismissMode = .onDrag

		self.collectionView?.delegate = self
		self.collectionView?.dataSource = self
	}

	public func subview(view: UIView) {
		guard let collection = collectionView else { return }

		view.addSubview(collection)
		NSLayoutConstraint.activate([
			collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collection.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
		])
	}

	public func reload() {
		DispatchQueue.main.async { [weak self] in
			self?.collectionView?.reloadData()
		}
	}

	public func insertItems(at: [IndexPath]) {
		DispatchQueue.main.async { [weak self] in
			if at.first?.row ?? 0 > 0 {
				self?.collectionView?.performBatchUpdates({
					self?.collectionView?.insertItems(at: at)
				}, completion: { _ in })
			} else {
				self?.collectionView?.reloadData()
			}
		}
	}

	private let reuseIdentifier = "Cell"
	private var noArtworkImage = UIImage(named: "noArtwork")!
}

extension SearchCollectionViewAdapter: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
		CGSize(width: collectionView.frame.size.width, height: SearchCell.height())
	}

	func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
		viewModel?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCell
		guard let model = viewModel else { return cell }
		let cellModel = model.model(indexPath.row)
		cell.configureCell(cellModel, noArtworkImage: noArtworkImage)
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
		viewModel?.checkLast(indexPath.row)
	}

	public func loadImage(artworkUrl: String?, completion: @escaping (UIImage, String) -> Void) {
		imageService.download(path: artworkUrl) { image, path in
			completion(image, path)
		}
	}
}
