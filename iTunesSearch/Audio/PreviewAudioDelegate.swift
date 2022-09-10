//
//  PreviewAudioDelegate.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

protocol PreviewAudioDelegate: AnyObject {
	func beginDownloadSong()
	func cancelDownloadSong()
	func beginPlay()
	func stopPlay()
	func updateData(text: String, progress: Float)
	func error()
}
