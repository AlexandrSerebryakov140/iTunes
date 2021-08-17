//
//  PreviewTitleLabel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

struct TitleLabelModel {
	public var horizontalAttributedText: NSAttributedString
	public let horizontalNumberOfLines: Int
	public let verticalAttributedText: NSAttributedString
	public let verticalNumberOfLines: Int

	private static let nameColor: UIColor = .darkGray
	private static let stringColor: UIColor = .lightGray
	private static let oneWordFont = UIFont.systemFont(ofSize: 19, weight: .semibold)

	init(name: String?, album: String?) {
		horizontalNumberOfLines = 1

		if album != nil {
			horizontalAttributedText = TitleLabelModel.twoWord(name: name, album: album, separate: " - ", fontSize: 13)
			verticalAttributedText = TitleLabelModel.twoWord(name: name, album: album, separate: "\n", fontSize: 16)
			verticalNumberOfLines = 2
		} else {
			horizontalAttributedText = TitleLabelModel.oneWord(name: name)
			verticalAttributedText = TitleLabelModel.oneWord(name: name)
			verticalNumberOfLines = 1
		}
	}

	private static func aString(
		name: String?,
		font: UIFont,
		color: UIColor
	) -> NSAttributedString {
		let string = name ?? ""
		let attr = [
			NSAttributedString.Key.foregroundColor: color,
			NSAttributedString.Key.font: font,
		]
		return NSAttributedString(string: string, attributes: attr)
	}

	private static func twoWord(
		name: String?,
		album: String?,
		separate: String,
		fontSize: CGFloat
	) -> NSAttributedString {
		let firstFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
		let secondFont = UIFont.systemFont(ofSize: fontSize)
		let firstString = aString(name: name, font: firstFont, color: nameColor)
		let separateString = aString(name: separate, font: firstFont, color: nameColor)
		let secondString = aString(name: album, font: secondFont, color: stringColor)

		let attrString = NSMutableAttributedString(attributedString: firstString)
		attrString.append(separateString)
		attrString.append(secondString)

		return attrString
	}

	private static func oneWord(name: String?) -> NSAttributedString {
		aString(name: name, font: oneWordFont, color: nameColor)
	}
}

final class PreviewTitleLabel: UILabel {
	init(titleModel: TitleLabelModel?, collection: UITraitCollection) {
		super.init(frame: .zero)
		backgroundColor = .clear
		textAlignment = .center

		guard let model = titleModel else { return }
		if isHorizontal(collection.horizontalSizeClass) {
			attributedText = model.horizontalAttributedText
			numberOfLines = model.horizontalNumberOfLines
		} else {
			attributedText = model.verticalAttributedText
			numberOfLines = model.verticalNumberOfLines
		}
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func isHorizontal(_ horizontal: UIUserInterfaceSizeClass) -> Bool {
		(horizontal == .regular) ? true : false
	}
}
