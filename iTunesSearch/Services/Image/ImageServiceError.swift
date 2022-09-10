//
//  ImageServiceError.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

public enum ImageServiceError: Error, Equatable, Logged {
	//        Logger.log(state: .error, message: "URL: Путь к изображению отсутствует")
	//        Logger.log(state: .error, message: "URL: Путь к изображению не явлется валидным URL")
	//    case error(NSError message: "Ошибка выполнения запроса")
//
	//    Logger.log(state: .error, message: "Загруженные данные не являются изображением")

	case path
	case notUrl(String)
	case error(NSError)
	case noData
	case notImage

	func text() -> String {
		switch self {
		case .path:
			return "Путь к изображению отсутствует"
		case let .notUrl(path):
			return "Путь к изображению '\(path)' не явлется валидным"
		case let .error(error):
			return error.localizedDescription
		case .noData:
			return "Данные отсутсвуют"
		case .notImage:
			return "Загруженные данные не являются изображением"
		}
	}

	func toLog() -> String {
		text()
	}
}
