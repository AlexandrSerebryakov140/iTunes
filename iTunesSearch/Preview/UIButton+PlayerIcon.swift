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
}

extension UIButton {
	func setImage(_ icon: PlayerIcon) {
		setImage(UIImage(named: icon.rawValue), for: .normal)
	}
}
