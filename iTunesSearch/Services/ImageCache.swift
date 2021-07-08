//
//  ImageCache.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation
import UIKit

final class ImageCache: NSCache<NSString, UIImage> {
	override init() {
		super.init()
		self.name = "ImageCache"
		self.countLimit = 350 // Максимальное количество изображений в памяти - 350
		self.totalCostLimit = 50 * 1_024 * 1_024 // Максимальный объем памяти 50 Мб
	}

	public func imageForKey(_ path: NSString) -> UIImage! {
		if let imageFromCache = object(forKey: path as NSString) {
			return imageFromCache
		}
		return nil
	}

	public func addImageForKey(_ path: NSString, image: UIImage) {
		func costFor(image: UIImage) -> Int {
			guard let imageRef = image.cgImage else {
				return 0
			}
			return imageRef.bytesPerRow * imageRef.height // Cost in bytes
		}

		setObject(image, forKey: path as NSString, cost: costFor(image: image))
	}
}
