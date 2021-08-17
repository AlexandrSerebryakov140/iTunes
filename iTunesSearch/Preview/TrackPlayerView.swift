//
//  PreviewViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.08.2021.
//

import UIKit

protocol PreviewAudioDelegate: AnyObject {
	func playerBeginDownloadSong()
	func playerBeginPlay()
	func playerStopPlay()
	func playerUpdateData(string: String, float: Float)
	func error()
}

final class TrackPlayerView: UIView {
	private lazy var trackInfoLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "Загрузить фрагмент"
		label.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
		label.textColor = .white
		return label
	}()

	private lazy var progressView: UIProgressView = {
		let progress = UIProgressView(frame: .zero)
		progress.progressViewStyle = .bar
		progress.progressTintColor = .red
		progress.trackTintColor = .white
		progress.progress = 0.0
		return progress
	}()

	private lazy var playerButton: UIButton = {
		let button = UIButton(frame: .zero)
		button.setImage(.download)
		return button
	}()

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public func setupButton(_ target: Any?, action: Selector) {
		playerButton.addTarget(target, action: action, for: [.touchUpInside])
	}

	private func commonInit() {
		layer.borderColor = UIColor.white.cgColor
		layer.borderWidth = 3.0
		clipsToBounds = true
		layer.cornerRadius = 10.0
		backgroundColor = UIColor(red: 1.00, green: 0.40, blue: 0.36, alpha: 1.0)

		addSubview(playerButton)
		addSubview(trackInfoLabel)
		addSubview(progressView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		playerButton.frame = CGRect(x: 10, y: (frame.height - 48) / 2, width: 48, height: 48)
		trackInfoLabel.frame = CGRect(x: 83, y: 11, width: frame.width - 92, height: 20)
		progressView.frame = CGRect(x: 83, y: frame.height - 14, width: frame.width - 92, height: 2)
	}
}

// MARK: - PreviewAudioDelegate

extension TrackPlayerView: PreviewAudioDelegate {
	func error() {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = "Error"
		}
	}

	func playerBeginDownloadSong() {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = "Загрузка фрагмента"
			self?.playerButton.rotate(duration: 1)
		}
	}

	func playerBeginPlay() {
		DispatchQueue.main.async { [weak self] in
			self?.playerButton.setImage(.pause)
			self?.playerButton.pulsate()
		}
	}

	func playerStopPlay() {
		DispatchQueue.main.async { [weak self] in
			self?.playerButton.setImage(.play)
			self?.playerButton.stopRotating()
			self?.playerButton.pulsate()
		}
	}

	func playerUpdateData(string: String, float: Float) {
		DispatchQueue.main.async { [weak self] in
			self?.trackInfoLabel.text = string
			self?.progressView.progress = float
		}
	}
}
