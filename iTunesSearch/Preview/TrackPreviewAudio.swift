//
//  PreviewViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import AudioToolbox
import AVFoundation

final class TrackPreviewAudio: NSObject {
	private var audioPlayer: AVAudioPlayer?
	public var updateState: (TrackPlayerState) -> Void = { _ in }
	public var updateTime: (String, Float) -> Void = { _, _ in }

	func startAudioPlayer(_ previewFileURL: URL!) {
		guard let preview = previewFileURL else { return }

		do {
			try audioPlayer = AVAudioPlayer(contentsOf: preview)
			audioPlayer?.delegate = self
			audioPlayer?.prepareToPlay()
		} catch let error as NSError {
			print("Ошибка инициализации плеера:", error.localizedDescription)
			updateState(.error)
			return
		}

		stopPlay()
	}

	public func stopPlay() {
		audioPlayer?.stop()
		stopTimer()
		updateState(.trackStop)
	}

	public func beginPlay() {
		audioPlayer?.play()
		runTimer()
		updateState(.trackPlay)
	}

	private var playerTimer: Timer?

	private func runTimer() {
		playerTimer = Timer.scheduledTimer(
			withTimeInterval: 0.05,
			repeats: true
		) { [weak self] _ in
			self?.updatePlayerTime()
		}
	}

	private func stopTimer() {
		playerTimer?.invalidate()
		updatePlayerTime()
	}

	private func updatePlayerTime() {
		guard let player = audioPlayer else { return }
		let str = String(format: "%.1f / %.1f", player.currentTime, player.duration)
		let flt = Float(player.currentTime / player.duration)
		updateTime(str, flt)
	}

	deinit {
		stopPlay()
	}
}

// MARK: - AVAudioPlayerDelegate

extension TrackPreviewAudio: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully _: Bool) {
		stopPlay()
	}

	func audioPlayerDecodeErrorDidOccur(_: AVAudioPlayer, error _: Error?) {
		updateState(.error)
	}
}
