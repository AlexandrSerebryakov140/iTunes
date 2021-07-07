//
//  SearchViewCell.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

final class SearchViewCell: UICollectionViewCell {
	let artwork: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.borderWidth = 0.8
		imageView.layer.cornerRadius = 7
		imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		return imageView
	}()

	let name: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
		label.textColor = .black
		label.text = "Название трека"
		return label
	}()

	let author: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
		label.textColor = .lightGray
		label.text = "Автор трека"
		return label
	}()

	let time: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
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

		NSLayoutConstraint.activate([
			artwork.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
			artwork.topAnchor.constraint(equalTo: topAnchor, constant: 6),
			name.topAnchor.constraint(equalTo: topAnchor, constant: 6),
			name.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
			author.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 10),
			bottomAnchor.constraint(equalTo: author.bottomAnchor, constant: 10),
			bottomAnchor.constraint(equalTo: time.bottomAnchor, constant: 10),
			trailingAnchor.constraint(greaterThanOrEqualTo: time.trailingAnchor, constant: 20),
			trailingAnchor.constraint(greaterThanOrEqualTo: name.trailingAnchor, constant: 20),
		])
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	override func awakeFromNib() {
		super.awakeFromNib()
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

	func configureCell(_ cellModel: SearchCellViewModel) {
		name.text = cellModel.trackName
		author.text = cellModel.artistName
		time.text = cellModel.trackLenght
	}

	override func prepareForReuse() {
		artwork.image = nil
		super.prepareForReuse()
	}
}
