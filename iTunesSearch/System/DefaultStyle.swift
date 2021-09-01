//
//  DefaultStyle.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 01.09.2021.
//

import Foundation
import UIKit

public enum DefaultStyle {
	public enum Colors {
		public static let white: UIColor = {
			.white
		}()

		public static let red: UIColor = {
			.red
		}()

		public static let label: UIColor = {
			isNotDark ? .black : .white
		}()

		public static let background: UIColor = {
			isNotDark ? .white : .black
		}()

		public static let lightGray: UIColor = {
			isNotDark ? .lightGray : .darkGray
		}()

		public static let darkGray: UIColor = {
			isNotDark ? .darkGray : .lightGray
		}()

		public static let redBackground: UIColor = {
			isNotDark ? UIColor(red: 1.00, green: 0.40, blue: 0.36, alpha: 1.0) : .systemRed
		}()

		public static let borderColor: UIColor = {
			isNotDark ? .lightGray : .white
		}()

		private static let isNotDark: Bool = {
			if #available(iOS 13.0, *) {
				return UITraitCollection.current.userInterfaceStyle != .dark
			} else {
				return false
			}
		}()
	}
}
