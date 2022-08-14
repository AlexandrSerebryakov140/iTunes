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
	public var artworkUrl: String?

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

	public func configureCell(_ cellModel: SearchCellModel) {
		artworkUrl = cellModel.artworkUrl
		name.text = cellModel.trackName
		author.text = cellModel.artistName
		time.text = cellModel.trackLenght
		layoutIfNeeded()
	}

	public func configureCellImage(_ image: UIImage) {
		DispatchQueue.main.async { [weak self] in
			self?.artwork.image = image
			self?.layoutIfNeeded()
		}
	}

	class func height() -> CGFloat {
		65
	}

	override var isSelected: Bool {
		didSet {
			backgroundColor = isSelected ? DefaultStyle.Colors.lightGray.withAlphaComponent(0.2) : DefaultStyle.Colors.background
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

extension UIView {
	public func borderWithRadius(color: UIColor, width: CGFloat, radius: CGFloat) {
		layer.borderColor = color.cgColor
		layer.borderWidth = width
		clipsToBounds = true
		layer.cornerRadius = radius
	}
}
