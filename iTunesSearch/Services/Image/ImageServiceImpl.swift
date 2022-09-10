//
//  ImageManager.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation
import UIKit

public final class ImageServiceImpl: ImageService {
	private let imageCache: ImageCache
	private let session: URLSession

	init(session: URLSession, imageCache: ImageCache) {
		self.session = session
		self.imageCache = imageCache
	}

	public func download(
		path: String?,
		completion: @escaping (_ image: UIImage, _ path: String) -> Void,
		failure: @escaping (_ error: ImageServiceError) -> Void
	) {
		guard let downloadPath = path else {
			Logger.log(state: .error, message: "URL: Путь к изображению отсутствует")
			failure(.path)
			return
		}

		guard let url = URL(string: downloadPath) else {
			Logger.log(state: .error, message: "URL: Путь к изображению не явлется валидным URL")
			failure(.notUrl(downloadPath))
			return
		}

		// проверяем есть ли закешированное изображение, если есть - возвращаем его
		if let imageFromCache = self.imageCache.imageForKey(path: downloadPath) {
			completion(imageFromCache, downloadPath)
			return
		}

		// если нет - грузим
		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)

		session.dataTask(with: request, completionHandler: { [weak self] data, _, error in

			if let err = error as? NSError {
				let description = String(describing: err.localizedDescription)
				Logger.log(state: .error, message: "Ошибка загрузки, \(description)")
				failure(.error(err))
				return
			}

			guard let responseData = data else {
				failure(.noData)
				return
			}

			guard let image = UIImage(data: responseData) else {
				Logger.log(state: .error, message: "Загруженные данные не являются изображением")
				failure(.notImage)
				return
			}

			// добавляем закачанное и распарсенное изоображение в кэш
			self?.imageCache.addImageForKey(path: downloadPath, image: image)

			completion(image, downloadPath)

		}).resume()
	}
}
