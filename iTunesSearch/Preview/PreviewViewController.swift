//
//  PreviewViewController.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

final class PreviewViewController: UIViewController {
	let viewModel: PreviewViewModel
	var layout: PreviewViewControllerLayout

	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	private lazy var trackPlayerView: TrackPlayerView = {
		let trackPlayer = TrackPlayerView(frame: .zero)
		trackPlayer.playerButton.addTarget(self, action: #selector(didTapPlayerButton), for: [.touchUpInside])
		trackPlayer.translatesAutoresizingMaskIntoConstraints = false
		return trackPlayer
	}()

	init(viewModel: PreviewViewModel, layout: PreviewViewControllerLayout) {
		self.viewModel = viewModel
		self.layout = layout
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		layout.layoutTrait(collection: view.traitCollection)
		updateNavigationBar(item: viewModel.item, collection: view.traitCollection)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		addToStackView(stackView: stackView, item: viewModel.item)

		viewModel.start({ [weak self] image in
			self?.imageView.image = image
		})

		viewModel.update(trackPlayerView)
	}

	private func setupView() {
		view.backgroundColor = .white
		view.addSubview(imageView)
		view.addSubview(stackView)
		view.addSubview(trackPlayerView)

		layout.setupConstraints(view: view, image: imageView, stack: stackView, player: trackPlayerView)
		layout.layoutTrait(collection: view.traitCollection)
		updateNavigationBar(item: viewModel.item, collection: view.traitCollection)
	}

	private func updateNavigationBar(item: iTunesItem, collection: UITraitCollection) {
		navigationItem.titleView = PreviewTitleLabel(item: item, collection: collection)
	}

	@objc
	func didTapPlayerButton() {
		viewModel.didTapButton()
	}
}

// MARK: - Вывод данных из iTunesItem в стек PreviewViewController

extension PreviewViewController {
	private func addToStackView(stackView: UIStackView, item: iTunesItem) {
		let item = viewModel.item

		if let track = item.trackName {
			stackView.addArrangedSubview(addLabel(track, fontSize: 28.0, color: .black))
		}

		if let artist = item.artistName {
			stackView.addArrangedSubview(addLabel(artist, fontSize: 18.0, color: .darkGray))
		}

		if let album = item.collectionName {
			stackView.addArrangedSubview(addLabel(album, fontSize: 18.0, color: .black))
		}
	}

	private func addLabel(_ text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
		let label = UILabel()
		label.textColor = color
		label.textAlignment = .center
		label.font = .systemFont(ofSize: fontSize)
		label.text = text
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		return label
	}
}
