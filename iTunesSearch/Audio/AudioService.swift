//
//  AudioService.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

protocol AudioService {
	func startAudioPlayer(_ previewFileURL: URL?)
	func stopPlay()
	func beginPlay()

	var updateState: (TrackPlayerState) -> Void { get set }
	var updateTime: (String, Float) -> Void { get set }
}
