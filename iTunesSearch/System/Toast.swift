//
//  SearchToast.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation
import UIKit

final class Toast {
	private static let textColor: UIColor = DefaultStyle.Colors.background
	private static let infoColor: UIColor = DefaultStyle.Colors.label.withAlphaComponent(0.6)
	private static let errorColor: UIColor = .red.withAlphaComponent(0.6)

	public static func show(message: String, controller: UIViewController?, isError: Bool = false) {
		DispatchQueue.main.async { [weak controller] in
			guard let viewController = controller else { return }
			let container = toastContainer(message: message, color: isError ? errorColor : infoColor)
			viewController.view.addSubview(container)
			constraints(container: container, view: viewController.view)
			animate(container: container)
		}
	}

	private static func animate(container: UIView) {
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
			container.alpha = 1.0
		}, completion: { _ in
			UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseOut, animations: {
				container.alpha = 0.0
			}, completion: { _ in
				container.removeFromSuperview()
			})
		})
	}

	private static var label: UILabel {
		let label = UILabel(frame: .zero)
		label.textColor = textColor
		label.textAlignment = .center
		label.font.withSize(12.0)
		label.clipsToBounds = true
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	private static func toastContainer(message: String, color: UIColor) -> UIView {
		let container = UIView(frame: .zero)
		container.alpha = 0.0
		container.backgroundColor = color
		container.layer.cornerRadius = 25.0
		container.clipsToBounds = true
		container.translatesAutoresizingMaskIntoConstraints = false

		let label = label
		label.text = message
		container.addSubview(label)
		label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 15).isActive = true
		label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15).isActive = true
		label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -15).isActive = true
		label.topAnchor.constraint(equalTo: container.topAnchor, constant: 15).isActive = true
		return container
	}

	private static func constraints(container: UIView, view: UIView) {
		container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65).isActive = true
		container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65).isActive = true
		container.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
	}
}
