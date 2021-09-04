//
//  DefaultStyle.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 01.09.2021.
//

import Foundation
import UIKit

public enum DefaultStyle {
	/// Сущность для поддержки темной темы
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

	public enum Fonts {
		public static let system18: UIFont = {
			UIFont.systemFont(ofSize: 18.0, weight: .regular)
		}()

		public static let semibold19: UIFont = {
			UIFont.systemFont(ofSize: 19.0, weight: .semibold)
		}()

		public static let system15: UIFont = {
			UIFont.systemFont(ofSize: 15.0, weight: .regular)
		}()

		public static let system19: UIFont = {
			UIFont.systemFont(ofSize: 19.0, weight: .regular)
		}()

		public static let first13: UIFont = {
			UIFont.systemFont(ofSize: 13.0, weight: .semibold)
		}()

		public static let first16: UIFont = {
			UIFont.systemFont(ofSize: 16.0, weight: .semibold)
		}()

		public static let second13: UIFont = {
			UIFont.systemFont(ofSize: 13.0, weight: .regular)
		}()

		public static let second16: UIFont = {
			UIFont.systemFont(ofSize: 16.0, weight: .regular)
		}()
	}
}
