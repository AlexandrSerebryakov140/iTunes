//
//  SearchToast.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation
import UIKit

final class SearchToast {
	static func toastContainer() -> UIView {
		let container = UIView(frame: CGRect())
		container.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		container.alpha = 0.0
		container.layer.cornerRadius = 25
		container.clipsToBounds = true
		container.translatesAutoresizingMaskIntoConstraints = false
		return container
	}

	static func toastLabel(_ message: String) -> UILabel {
		let label = UILabel(frame: CGRect())
		label.textColor = UIColor.white
		label.textAlignment = .center
		label.font.withSize(12.0)
		label.text = message
		label.clipsToBounds = true
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}

	static func show(message: String, controller: UIViewController) {
		DispatchQueue.main.async {
			let toastContainer = self.toastContainer()
			let toastLabel = self.toastLabel(message)
			toastContainer.addSubview(toastLabel)
			controller.view.addSubview(toastContainer)

			NSLayoutConstraint.activate([
				toastLabel.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 15),
				toastLabel.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -15),
				toastLabel.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -15),
				toastLabel.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 15),
				toastContainer.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 65),
				toastContainer.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -65),
				toastContainer.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: 160),
			])

			UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
				toastContainer.alpha = 1.0
			}, completion: { _ in
				UIView.animate(withDuration: 0.5, delay: 1.2, options: .curveEaseOut, animations: {
					toastContainer.alpha = 0.0
				}, completion: { _ in
					toastContainer.removeFromSuperview()
				})
			})
		}
	}
}
