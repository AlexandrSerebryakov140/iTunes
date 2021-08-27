//
//  UIView+Extension.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 27.08.2021.
//

import UIKit

extension UIView {
	public func borderWithRadius(color: UIColor, width: CGFloat, radius: CGFloat) {
		layer.borderColor = color.cgColor
		layer.borderWidth = width
		clipsToBounds = true
		layer.cornerRadius = radius
	}
}
