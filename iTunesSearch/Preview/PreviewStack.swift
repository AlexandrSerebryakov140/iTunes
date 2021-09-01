//
//  PreviewStack.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 01.09.2021.
//

import Foundation
import UIKit

struct PreviewStackItem {
	enum StackType {
		case trackName
		case artistName
		case collectionName
		case description
		case longDescription

		var rawValue: (CGFloat, UIColor) {
			switch self {
			case .trackName: return (24.0, DefaultStyle.Colors.label)
			case .artistName: return (18.0, DefaultStyle.Colors.darkGray)
			case .collectionName: return (18.0, color: DefaultStyle.Colors.label)
			case .description: return (16.0, color: DefaultStyle.Colors.label)
			case .longDescription: return (14.0, DefaultStyle.Colors.darkGray)
			}
		}
	}

	func color() -> UIColor {
		type.rawValue.1
	}

	func fontSize() -> CGFloat {
		type.rawValue.0
	}

	let text: String
	let type: StackType
}

enum PreviewStack {
	static func builder(item: iTunesItem) -> [PreviewStackItem] {
		var items: [PreviewStackItem] = []

		if let track = item.trackName, let time = item.trackLenght {
			items.append(PreviewStackItem(text: "\(track) [\(time)]", type: .trackName))
		}

		if let artist = item.artistName {
			items.append(PreviewStackItem(text: artist, type: .artistName))
		}

		if let album = item.collectionName {
			items.append(PreviewStackItem(text: album, type: .collectionName))
		}

		if let description = item.description {
			items.append(PreviewStackItem(text: description, type: .description))
		}

		if let longDescription = item.longDescription {
			items.append(PreviewStackItem(text: longDescription, type: .longDescription))
		}

		return items
	}

	static func stackViewLabel(_ item: PreviewStackItem) -> UILabel {
		let label = UILabel(frame: .zero)
		label.textColor = item.color()
		label.textAlignment = .center
		label.font = .systemFont(ofSize: item.fontSize())
		label.text = item.text
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
		return label
	}
}
