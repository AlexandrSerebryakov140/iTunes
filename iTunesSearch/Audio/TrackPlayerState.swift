//
//  TrackPlayerState.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

enum TrackPlayerState: String {
	case none // исходное состояние
	case trackIsDownloaded // фрагмент трека загружается
	case trackStop // трек загружен но остановлен
	case trackPlay // трек играется
	case error // ошибка
}
