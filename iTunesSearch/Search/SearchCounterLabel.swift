//
//  SearchCounterLabel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import UIKit

final class SearchCounterLabel: UILabel {
	private weak var viewModel: SearchViewModel?

	init(viewModel: SearchViewModel?) {
		self.viewModel = viewModel
		super.init(frame: .zero)
		font = UIFont.systemFont(ofSize: 18.0)
		numberOfLines = 1
		textAlignment = .center
		isUserInteractionEnabled = false
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		guard let supersize = superview?.frame.size else { return }
		let width = 60
		let height = 40
		let x = Int(supersize.width) - width - 10
		let y = Int(supersize.height) - height - 10
		frame = CGRect(x: x, y: y, width: width, height: height)
	}

	public func update(count: Int) {
		DispatchQueue.main.async { [weak self] in
			self?.text = String(count)
			self?.textColor = count == 0 ? .clear : .darkGray
		}
	}

	public func searching() {
		DispatchQueue.main.async { [weak self] in
			self?.text = "!"
			self?.textColor = .darkGray
		}
	}
}
