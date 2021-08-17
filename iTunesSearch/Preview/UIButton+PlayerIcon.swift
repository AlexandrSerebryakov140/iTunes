//
//  UIButton+PlayerIcon.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.08.2021.
//

import UIKit

// MARK: - Обработка иконок кнопки

enum PlayerIcon: String {
	case download
	case pause
	case play
	case noArtwork
}

extension UIImage {
	convenience init(_ icon: PlayerIcon) {
		self.init(named: icon.rawValue)!
	}
}

extension UIButton {
	func setImage(_ icon: PlayerIcon) {
		setImage(UIImage(icon), for: .normal)
	}
}
