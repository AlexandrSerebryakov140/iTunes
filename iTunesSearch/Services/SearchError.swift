//
//  SearchError.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

public enum SearchError: Error, Equatable {
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

public enum FileDownloadError: Error, Equatable {
	case error(NSError)
	case url
}
