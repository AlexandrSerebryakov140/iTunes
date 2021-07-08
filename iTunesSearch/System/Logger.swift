//
//  Logger.swift
//  iTunesSearch
//
//  Created by Alexandr on 08.07.2021.
//

import Foundation

final class Logger {
	public enum State {
		case error
		case info
	}

	static func log(state: State, message: String) {
		switch state {
		case .error:
			print("Ошибка:", message)
		case .info:
			print(message)
		}
	}
}
