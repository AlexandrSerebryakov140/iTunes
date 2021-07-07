//
//  SearchCounterLabel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import UIKit

final class SearchCounterLabel: UILabel {
	override init(frame: CGRect) {
		super.init(frame: frame)
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont.systemFont(ofSize: 22.0)
		numberOfLines = 0
		text = "1"
		textAlignment = .center
		isUserInteractionEnabled = true
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func update(value: Int) {
		text = String(value)
		textColor = value == 0 ? .clear : .darkGray
	}
}
