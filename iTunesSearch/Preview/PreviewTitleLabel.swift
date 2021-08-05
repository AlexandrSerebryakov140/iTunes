//
//  PreviewTitleLabel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

class PreviewTitleLabel: UILabel {
	private let name: String?
	private let album: String?

	init(item: iTunesItem, collection: UITraitCollection) {
		name = item.trackName
		album = item.collectionName
		let horizontal = collection.horizontalSizeClass
		super.init(frame: .zero)
		backgroundColor = .clear
		textAlignment = .center
		if album != nil {
			attributedText = nameByOrientation(horizontal)
			numberOfLines = linesByOrientation(horizontal)
		} else {
			attributedText = oneWord()
			numberOfLines = 1
		}
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func isHorizontal(_ horizontal: UIUserInterfaceSizeClass) -> Bool {
		(horizontal == .regular) ? true : false
	}

	private func addString(name: String?, font: UIFont, color: UIColor = .black) -> NSAttributedString {
		let string = name ?? ""
		let attr = [
			NSAttributedString.Key.foregroundColor: color,
			NSAttributedString.Key.font: font,
		]
		return NSAttributedString(string: string, attributes: attr)
	}

	private func twoWord(separate: String, fontSize: CGFloat) -> NSAttributedString {
		let nameColor: UIColor = .darkGray
		let stringColor: UIColor = .lightGray
		let firstFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
		let secondFont = UIFont.systemFont(ofSize: fontSize)
		let firstString = addString(name: name, font: firstFont, color: nameColor)
		let separateString = addString(name: separate, font: firstFont, color: nameColor)
		let secondString = addString(name: album, font: secondFont, color: stringColor)

		let attrString = NSMutableAttributedString(attributedString: firstString)
		attrString.append(separateString)
		attrString.append(secondString)

		return attrString
	}

	private func oneWord() -> NSAttributedString {
		let nameColor: UIColor = .darkGray
		let font = UIFont.systemFont(ofSize: 19, weight: .semibold)
		return addString(name: name, font: font, color: nameColor)
	}

	private func nameByOrientation(_ horizontal: UIUserInterfaceSizeClass) -> NSAttributedString {
		if isHorizontal(horizontal) {
			return twoWord(separate: " - ", fontSize: 13)
		} else {
			return twoWord(separate: "\n", fontSize: 16)
		}
	}

	private func linesByOrientation(_ horizontal: UIUserInterfaceSizeClass) -> Int {
		isHorizontal(horizontal) ? 1 : 2
	}
}
