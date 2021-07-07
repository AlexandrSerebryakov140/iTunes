//
//  SearchCellViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation

struct SearchCellViewModel {
	let trackName: String?
	let artistName: String?
	let trackLenght: String?
	let artworkUrl: String?

	//    init(_ item: iTunesItem) {
	//        trackName = item.trackName
	//        artistName = item.artistName
	//        trackLenght = SearchCellViewModel.trackLenght(item.trackTimeMillis)
	//        artworkUrl = item.artworkUrl100
	//    }

	// возвращает время в виде строки формата Ч:ММ:CC либо пустую строку
	static func trackLenght(_ trackTimeMillis: Int?) -> String {
		guard let timeMillis = trackTimeMillis else {
			return ""
		}

		let lenght: Int = timeMillis / 1_000
		let seconds: Int = lenght % 60
		let minutes: Int = (lenght / 60) % 60
		let hours: Int = lenght / 3_600

		if hours > 0 {
			return String(format: "%d:%02d:%02d", hours, minutes, seconds)
		} else {
			return String(format: "%d:%02d", minutes, seconds)
		}
	}
}
