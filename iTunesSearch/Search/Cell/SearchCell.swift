//
//  SearchViewCell.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

final class SearchCell: UICollectionViewCell {
	let artwork: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.clipsToBounds = true
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.borderWidth = 0.8
		imageView.layer.cornerRadius = 7
		return imageView
	}()

	let name: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
		label.textColor = .black
		label.text = "Название трека"
		return label
	}()

	let author: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
		label.textColor = .lightGray
		label.text = "Автор трека"
		return label
	}()

	let time: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
		label.textColor = .lightGray
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

	public func configureCell(_ cellModel: SearchCellModel) {
		name.text = cellModel.trackName
		author.text = cellModel.artistName
		time.text = cellModel.trackLenght(cellModel.trackTimeMillis)
		layoutIfNeeded()
	}

	class func height() -> CGFloat {
		65
	}

	override var isSelected: Bool {
		didSet {
			if isSelected {
				backgroundColor = .lightGray.withAlphaComponent(0.2)
			} else {
				backgroundColor = .white
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
