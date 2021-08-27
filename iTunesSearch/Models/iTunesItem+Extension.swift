//
//  iTunesItem+Extension.swift
//  iTunesSearch
//
//  Created by Alexandr on 27.08.2021.
//

import Foundation

extension iTunesItem {
	/// возвращает ссылку на обложку альбома в высоком разрешении
	public var artworkUrl600: String {
		(artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600"))!
	}

	/// возвращает время в виде строки формата Ч:ММ:CC либо nil
	public var trackLenght: String? {
		guard let timeMillis = trackTimeMillis else { return nil }

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

	public func toCellModel() -> SearchCellModel {
		SearchCellModel(trackName: trackName, artistName: artistName, artworkUrl: artworkUrl100, trackLenght: trackLenght)
	}
}
