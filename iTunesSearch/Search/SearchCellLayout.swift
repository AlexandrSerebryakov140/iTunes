//
//  SearchCellLayout.swift
//  iTunesSearch
//
//  Created by Alexandr on 10.07.2021.
//

import UIKit

struct SearchCellLayout {
	let artwork: CGRect
	let name: CGRect
	let time: CGRect
	let author: CGRect

	init(frame: CGRect, name: UILabel, time: UILabel, author: UILabel) {
		artwork = CGRect(x: 14, y: 6, width: 50, height: 50)

		let nameSize = name.size()
		self.name = CGRect(
			x: 74,
			y: 6,
			width: min(frame.width - 74 - 10, nameSize.width),
			height: nameSize.height
		)

		let timeSize = time.size()
		self.time = CGRect(
			x: frame.width - 10 - timeSize.width,
			y: frame.height - 10 - timeSize.height,
			width: timeSize.width,
			height: timeSize.height
		)

		let authorSize = author.size()
		self.author = CGRect(
			x: 74,
			y: frame.height - authorSize.height - 10,
			width: min(frame.width - 74 - 10 - timeSize.width, authorSize.width),
			height: authorSize.height
		)
	}
}

extension UILabel {
	fileprivate func size() -> CGSize {
		func attributes(_ lFont: UIFont) -> [NSAttributedString.Key: Any] {
			[NSAttributedString.Key.font: lFont]
		}

		guard let labelFont = font else {
			return CGSize(width: 0, height: 0)
		}

		guard let size = text?.size(withAttributes: attributes(labelFont)) else {
			return CGSize(width: 0, height: 0)
		}
		return size
	}
}
