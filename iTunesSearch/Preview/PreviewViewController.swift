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

	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		return imageView
	}()

	private lazy var textView: UIView = {
		let textView = UIView(frame: .zero)
		textView.addSubview(stackView)
		stackView.topAnchor.constraint(equalTo: textView.topAnchor, constant: 0).isActive = true
		stackView.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 0).isActive = true
		stackView.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 0).isActive = true
		return textView
	}()

	private lazy var stackView: UIStackView = {
		let stackView = UIStackView(frame: .zero)
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .fill
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()

	init(viewModel: PreviewViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if UIApplication.shared.statusBarOrientation.isLandscape {
			let width = view.frame.height * 0.8
			let navBarHeight = navigationController?.navigationBar.frame.height
			imageView.frame = CGRect(x: 20, y: 20 + navBarHeight!, width: width, height: width)
			textView.frame = CGRect(x: 20 + width + 20, y: 20 + navBarHeight!, width: view.frame.width - width - navBarHeight! - 20, height: width)
			stackView.alignment = .leading
		} else {
			let width = view.frame.width * 0.7
			let navBarHeight = navigationController?.navigationBar.frame.height
			imageView.frame = CGRect(x: (view.frame.width - width) / 2, y: 20 + navBarHeight!, width: width, height: width)
			textView.frame = CGRect(x: (view.frame.width * 0.1) / 2, y: 20 + navBarHeight! + width + 20, width: view.frame.width * 0.9, height: view.frame.height - width - navBarHeight! - 20 - 20)
			stackView.alignment = .center
		}
		stackView.layoutIfNeeded()
		updateNavigationBar()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		view.addSubview(imageView)
		view.addSubview(textView)

		viewModel.start(updateImage: { image in
			self.imageView.image = image
		})

		let item = viewModel.item

		if let track = item.trackName {
			stackView.addArrangedSubview(label(track, fontSize: 28.0, color: .black))
		}

		if let artist = item.artistName {
			stackView.addArrangedSubview(label(artist, fontSize: 21.0, color: .darkGray))
		}

		if let album = item.collectionName {
			stackView.addArrangedSubview(label(album, fontSize: 21.0, color: .black))
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.update()
		updateNavigationBar()
	}

	func label(_ text: String, fontSize: CGFloat, color: UIColor) -> UILabel {
		let label = UILabel()
		label.textColor = color
		label.textAlignment = .center
		label.font = .systemFont(ofSize: fontSize)
		label.text = text
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.sizeToFit()
		label.layoutIfNeeded()
		return label
	}

	func updateNavigationBar() {
		let item = viewModel.item

		if let collectionName = item.collectionName {
			self.navigationItem.titleView = previewTitle(name: item.trackName, album: collectionName)
		} else {
			self.title = item.trackName
		}
	}
}

extension PreviewViewController {
	func isAlbum(_ orientation: UIDeviceOrientation) -> Bool {
		(orientation == .landscapeLeft || orientation == .landscapeRight) ? true : false
	}

	func previewTitle(name: String?, album: String?) -> UILabel {
		func addString(name: String?, font: UIFont, color: UIColor = .black) -> NSAttributedString {
			let string = name ?? ""
			let attr = [
				NSAttributedString.Key.foregroundColor: color,
				NSAttributedString.Key.font: font,
			]
			return NSAttributedString(string: string, attributes: attr)
		}

		func twoWord(name: String?, string: String?, separate: String, fontSize: CGFloat) -> NSAttributedString {
			let nameColor: UIColor = .darkGray
			let stringColor: UIColor = .lightGray
			let firstFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
			let secondFont = UIFont.systemFont(ofSize: fontSize)
			let firstString = addString(name: name, font: firstFont, color: nameColor)
			let separateString = addString(name: separate, font: firstFont, color: nameColor)
			let secondString = addString(name: string, font: secondFont, color: stringColor)

			let attrString = NSMutableAttributedString(attributedString: firstString)
			attrString.append(separateString)
			attrString.append(secondString)

			return attrString
		}

		func nameByOrientation() -> NSAttributedString {
			if isAlbum(UIDevice.current.orientation) {
				return twoWord(name: name, string: album, separate: " - ", fontSize: 13)
			} else {
				return twoWord(name: name, string: album, separate: "\n", fontSize: 16)
			}
		}

		func linesByOrientation() -> Int {
			isAlbum(UIDevice.current.orientation) ? 1 : 2
		}

		let label = UILabel()
		label.backgroundColor = .clear
		label.textAlignment = .center
		label.attributedText = nameByOrientation()
		label.numberOfLines = linesByOrientation()
		return label
	}
}
