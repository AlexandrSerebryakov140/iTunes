//
//  ImageManager.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation
import UIKit

public enum ImageServiceError: Error, Equatable {
	case error(NSError)
	case text(String)
	case request
	case responce
	case notFound(String)
	case notUpdate

	func text() -> String {
		switch self {
		case let .error(error):
			return error.localizedDescription
		case let .text(string):
			return string
		case .request:
			return "Неправильный запрос"
		case .responce:
			return "Пустой ответ"
		case let .notFound(search):
			return "По запросу '\(search)' ничего не найдено"
		case .notUpdate:
			return "Больше элементов нет"
		}
	}
}

protocol ImageService {
	func download(
		path: String?,
		completion: @escaping (_ image: UIImage, _ path: String) -> Void,
		failure: @escaping (_ error: ImageServiceError) -> Void
	)
}

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
		failure _: @escaping (_ error: ImageServiceError) -> Void
	) {
		guard let downloadPath = path else {
			Logger.log(state: .error, message: "URL: Путь к изображению отсутствует")
			return
		}

		guard let url = URL(string: downloadPath) else {
			Logger.log(state: .error, message: "URL: Путь к изображению не явлется валидным URL")
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

			guard let responseData = data, error == nil else {
				Logger.log(state: .error, message: "загрузки, \(String(describing: error?.localizedDescription))")
				return
			}

			guard let image = UIImage(data: responseData) else {
				Logger.log(state: .error, message: "Загруженные данные не являются изображением")
				return
			}

			// добавляем закачанное и распарсенное изоображение в кэш
			self?.imageCache.addImageForKey(path: downloadPath, image: image)

			completion(image, downloadPath)

		}).resume()
	}
}
