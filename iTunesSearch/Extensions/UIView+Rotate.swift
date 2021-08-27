//
//  UIView+Rotate.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.08.2021.
//

import UIKit

// MARK: - Анимации

extension UIView {
	/// Поворот UIView на указанный угол
	func rotate(angle: CGFloat) {
		let radians = angle / 180.0 * CGFloat.pi
		let rotation = transform.rotated(by: radians)
		self.transform = rotation
	}

	private static let kRotationAnimationKey = "rotationanimationkey"

	/// # Начать вращение UIView с указанной скоростью
	/// - parameter duration: скорость в единицах

	func rotate(duration: Double = 1) {
		if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
			let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

			rotationAnimation.fromValue = 0.0
			rotationAnimation.toValue = Float.pi * 2.0
			rotationAnimation.duration = duration
			rotationAnimation.repeatCount = Float.infinity

			layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
		}
	}

	/// Остановить вращение UIView
	func stopRotating() {
		if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
			layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
		}
	}
}

extension UIView {
	private static let kPulsateAnimationKey = "pulsateanimationkey"

	@objc
	func pulsate() {
		let pulse = CASpringAnimation(keyPath: "transform.scale")
		pulse.duration = 0.4
		pulse.fromValue = 0.7
		pulse.toValue = 1.0
		pulse.repeatCount = 0
		layer.add(pulse, forKey: UIView.kPulsateAnimationKey)
	}
}
