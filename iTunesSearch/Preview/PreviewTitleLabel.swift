//
//  PreviewTitleLabel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

private enum HVType: Equatable {
	case first
	case second
	case separate
}

private enum TitleLabelSizeClass: Equatable {
	case horisontal
	case vertical

	private typealias aKey = NSAttributedString.Key
	private typealias aFont = DefaultStyle.Fonts
	private typealias aColor = DefaultStyle.Colors

	private func firstFont() -> UIFont { self == .horisontal ? aFont.first13 : aFont.first16 }

	private func secondFont() -> UIFont { self == .horisontal ? aFont.second13 : aFont.second16 }

	private func firstColor() -> UIColor { aColor.darkGray }

	private func secondColor() -> UIColor { aColor.lightGray }

	private func color(type: HVType) -> UIColor {
		switch type {
		case .first: return firstColor()
		case .second: return secondColor()
		case .separate: return firstColor()
		}
	}

	private func font(type: HVType) -> UIFont {
		switch type {
		case .first: return firstFont()
		case .second: return secondFont()
		case .separate: return firstFont()
		}
	}

	func separate() -> String { self == .horisontal ? " - " : "\n" }

	func aString(name: String, type: HVType) -> NSAttributedString {
		let attr = [aKey.foregroundColor: color(type: type), aKey.font: font(type: type)]
		return NSAttributedString(string: name, attributes: attr)
	}
}

struct TitleLabelModel {
	public var horizontalAttributedText: NSAttributedString
	public let horizontalNumberOfLines = 1
	public let verticalAttributedText: NSAttributedString
	public var verticalNumberOfLines = 1

	init(name: String?, album: String?) {
		if album != nil {
			horizontalAttributedText = TitleLabelModel.twoWord(name: name, album: album, data: .horisontal)
			verticalAttributedText = TitleLabelModel.twoWord(name: name, album: album, data: .vertical)
			verticalNumberOfLines = 2
		} else {
			horizontalAttributedText = TitleLabelModel.oneWord(name: name)
			verticalAttributedText = TitleLabelModel.oneWord(name: name)
		}
	}

	private static func twoWord(name: String?, album: String?, data: TitleLabelSizeClass) -> NSAttributedString {
		let attrString = NSMutableAttributedString()
		attrString.append(data.aString(name: name ?? "", type: .first))
		attrString.append(data.aString(name: data.separate(), type: .separate))
		attrString.append(data.aString(name: album ?? "", type: .second))
		return attrString
	}

	private static func oneWord(name: String?) -> NSAttributedString {
		typealias aKey = NSAttributedString.Key
		let color = DefaultStyle.Colors.darkGray
		let font = DefaultStyle.Fonts.semibold19
		let attr = [aKey.foregroundColor: color, aKey.font: font]
		return NSAttributedString(string: name ?? "", attributes: attr)
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

	private func isHorizontal(_ horizontal: UIUserInterfaceSizeClass) -> Bool {
		(horizontal == .regular) ? true : false
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
