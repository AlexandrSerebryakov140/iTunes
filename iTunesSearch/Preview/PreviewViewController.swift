//
//  PreviewViewController.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 10.07.2021.
//

import Foundation
import UIKit

final class PreviewViewController: UIViewController {
	private let viewModel: PreviewViewModel
	private var titleModel: TitleLabelModel?
	private var layout: PreviewViewControllerLayout

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
		trackPlayer.setupButton(self, action: #selector(didTapPlayerButton))
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
		updateNavigationBar(collection: view.traitCollection)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()

		viewModel.updateImage = { [weak self] image in
			self?.updateImageView(image: image)
		}

		viewModel.updateStack = { [weak self] items in
			self?.updateStackView(items: items)
		}

		viewModel.updateTitleModel = { [weak self] model in
			self?.updateTitleModel(model: model)
		}

		viewModel.start(audioDelegate: trackPlayerView)
	}

	private func setupView() {
		view.backgroundColor = .white
		view.addSubview(imageView)
		view.addSubview(stackView)
		view.addSubview(trackPlayerView)

		layout.setupConstraints(view: view, image: imageView, stack: stackView, player: trackPlayerView)
		layout.layoutTrait(collection: view.traitCollection)
	}

	private func updateNavigationBar(collection: UITraitCollection) {
		navigationItem.titleView = PreviewTitleLabel(titleModel: titleModel, collection: collection)
	}

	@objc
	func didTapPlayerButton() {
		viewModel.didTapButton()
	}
}

// MARK: - Вывод данных из iTunesItem в стек PreviewViewController

extension PreviewViewController {
	private func updateImageView(image: UIImage) {
		DispatchQueue.main.async { [weak self] in
			self?.imageView.image = image
		}
	}

	private func updateStackView(items: [PreviewStackItem]) {
		DispatchQueue.main.async { [weak self] in
			items.forEach { item in
				if let label = self?.addStackViewLabel(item) {
					self?.stackView.addArrangedSubview(label)
				}
			}
		}
	}

	private func updateTitleModel(model: TitleLabelModel) {
		DispatchQueue.main.async { [weak self] in
			self?.titleModel = model
			if let collection = self?.view.traitCollection {
				self?.updateNavigationBar(collection: collection)
			}
		}
	}

	private func addStackViewLabel(_ item: PreviewStackItem) -> UILabel {
		let label = UILabel()
		label.textColor = item.color
		label.textAlignment = .center
		label.font = .systemFont(ofSize: item.fontSize)
		label.text = item.text
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.adjustsFontSizeToFitWidth = true
		return label
	}
}
