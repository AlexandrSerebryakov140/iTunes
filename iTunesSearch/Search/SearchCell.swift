//
//  SearchViewCell.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

public struct SearchCellModel {
	let trackName: String?
	let artistName: String?
	let artworkUrl: String?
	let trackLenght: String?
}

final class SearchCell: UICollectionViewCell {
	private var artworkUrl: String?

	private let artwork: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.borderWithRadius(color: DefaultStyle.Colors.lightGray, width: 0.8, radius: 7.0)
		return imageView
	}()

	private let name: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system19
		label.textColor = DefaultStyle.Colors.label
		label.text = "Название трека"
		return label
	}()

	private let author: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system15
		label.textColor = DefaultStyle.Colors.lightGray
		label.text = "Автор трека"
		return label
	}()

	private let time: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system15
		label.textColor = DefaultStyle.Colors.lightGray
		label.text = "02:00"
		return label
	}()

	override init(frame _: CGRect) {
		super.init(frame: .zero)
		contentView.addSubview(artwork)
		contentView.addSubview(name)
		contentView.addSubview(author)
		contentView.addSubview(time)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func configureCell(_ cellModel: SearchCellModel, noArtworkImage: UIImage) {
		artworkUrl = cellModel.artworkUrl
		name.text = cellModel.trackName
		author.text = cellModel.artistName
		time.text = cellModel.trackLenght
		artwork.image = noArtworkImage
		layoutIfNeeded()
	}

	public func setupImage(image: UIImage, path: String) {
		DispatchQueue.main.async { [weak self] in
			if self?.artworkUrl != path { return }
			self?.artwork.image = image
			self?.layoutIfNeeded()
		}
	}

	class func height() -> CGFloat {
		65
	}

	override var isSelected: Bool {
		didSet {
			if isSelected {
				backgroundColor = DefaultStyle.Colors.lightGray.withAlphaComponent(0.2)
			} else {
				backgroundColor = DefaultStyle.Colors.background
			}
		}
	}

	override func prepareForReuse() {
		artwork.image = nil
		super.prepareForReuse()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let layout = SearchCellLayout(
			frame: frame,
			name: name,
			time: time,
			author: author
		)

		artwork.frame = layout.artwork
		name.frame = layout.name
		time.frame = layout.time
		author.frame = layout.author
	}
}
