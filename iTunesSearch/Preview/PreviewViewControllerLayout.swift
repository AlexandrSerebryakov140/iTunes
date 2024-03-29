//
//  PreviewViewControllerLayout.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 14.07.2021.
//

import Foundation
import UIKit

struct PreviewViewControllerLayout {
	private var portraitConstraints: [NSLayoutConstraint] = []
	private var regularConstraints: [NSLayoutConstraint] = []

	public mutating func setupConstraints(view: UIView, image: UIView, stack: UIView, player: UIView) {
		let width = CGFloat(min(view.frame.height, view.frame.width, 600))

		portraitConstraints.append(contentsOf: [ // .isPortrait
			image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			image.widthAnchor.constraint(equalToConstant: width * 0.7),
			image.heightAnchor.constraint(equalToConstant: width * 0.7),

			stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			stack.topAnchor.constraint(equalTo: image.safeAreaLayoutGuide.bottomAnchor, constant: 10),

			player.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			player.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			player.heightAnchor.constraint(equalToConstant: 60),
			player.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
		])

		regularConstraints.append(contentsOf: [ // .isLandscape
			image.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
			image.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
			image.widthAnchor.constraint(equalToConstant: width * 0.8),
			image.heightAnchor.constraint(equalToConstant: width * 0.8),

			stack.topAnchor.constraint(equalTo: image.topAnchor),
			stack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
			stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),

			player.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
			player.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
			player.heightAnchor.constraint(equalToConstant: 60),
			player.bottomAnchor.constraint(equalTo: image.safeAreaLayoutGuide.bottomAnchor),
		])
	}

	public func layoutTrait(collection: UITraitCollection) {
		// для ориентации .isPortrait
		let horizontal = collection.horizontalSizeClass
		let vertical = collection.verticalSizeClass

		func deactivate(_ constraints: [NSLayoutConstraint]) {
			if !constraints.isEmpty, constraints[0].isActive {
				NSLayoutConstraint.deactivate(constraints)
			}
		}

		if collection.userInterfaceIdiom == .pad { // для iPad
			deactivate(regularConstraints)
			NSLayoutConstraint.activate(portraitConstraints)
		} else if horizontal == .compact, vertical == .regular { // для портретной ориентации
			deactivate(regularConstraints)
			NSLayoutConstraint.activate(portraitConstraints)
		} else if horizontal == .regular || horizontal == .compact, vertical == .compact { // для ориентации .isLandscape
			deactivate(portraitConstraints)
			NSLayoutConstraint.activate(regularConstraints)
		}
	}
}
