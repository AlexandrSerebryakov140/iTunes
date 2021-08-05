//
//  PreviewAudio.swift
//  iTunesSearchSwift
//
//  Created by Серебряков Александр on 28.07.2018.
//  Copyright © 2018. All rights reserved.
//

import AudioToolbox
import AVFoundation

class TrackPreviewAudio: NSObject {
	private var audioPlayer: AVAudioPlayer!
	private var playerTimer: Timer!
	weak var delegate: PreviewAudioDelegate?
	public var updateState: (TrackPlayerState) -> Void = { _ in }

	init(delegate: PreviewAudioDelegate?) {
		self.delegate = delegate
	}

	func startAudioPlayer(_ previewFileURL: URL!) {
		guard let preview = previewFileURL else { return }

		do {
			try audioPlayer = AVAudioPlayer(contentsOf: preview)
			audioPlayer.delegate = self
			updateState(.trackDownload)
		} catch let error as NSError {
			print("Ошибка инициализации плеера:", error.localizedDescription)
			updateState(.error)
			return
		}

		audioPlayer.prepareToPlay()

		DispatchQueue.main.async { [weak self] in
			self?.stopPlay()
		}
	}

	public func stopPlay() {
		updateState(.trackStop)
		audioPlayer.stop()
		delegate?.playerStopPlay()
		playerTimer?.invalidate()
		updateTime()
	}

	public func beginPlay() {
		updateState(.trackPlay)
		audioPlayer.play()
		delegate?.playerBeginPlay()
		playerTimer = Timer.scheduledTimer(
			timeInterval: 0.05,
			target: self,
			selector: #selector(updateTime),
			userInfo: nil,
			repeats: true
		)
	}

	@objc
	private func updateTime() {
		let str = String(format: "%.1f / %.1f", audioPlayer.currentTime, audioPlayer.duration)
		let flt = Float(audioPlayer.currentTime / audioPlayer.duration)
		delegate?.playerUpdateData(string: str, float: flt)
	}

	private func audioDisappear() {
		updateState(.none)
		audioPlayer?.stop()
		playerTimer?.invalidate()
		//  DataManager.removePreviewFile(previewFileURL: self.previewFileURL)
	}
}

// MARK: - AVAudioPlayerDelegate

extension TrackPreviewAudio: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
		stopPlay()
	}

	func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) {}
}
