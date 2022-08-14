//
//  SearchView.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 26.07.2022.
//

import UIKit

final class SearchView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		initSubviews()
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public func counterUpdate(_ count: Int? = 0) {
		DispatchQueue.main.async { [weak self] in
			self?.сounter.text = String(count ?? 0)
			self?.сounter.textColor = count == 0 ? .clear : .darkGray
		}
	}

	public func counterSearching() {
		DispatchQueue.main.async { [weak self] in
			self?.сounter.text = "!"
			self?.сounter.textColor = .darkGray
		}
	}

	private func initSubviews() {
		addSubview(collectionView)
		addSubview(сounter)
		NSLayoutConstraint.activate(subviewConstraints)
	}

	private lazy var subviewConstraints: [NSLayoutConstraint] = {
		[
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
			collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),

			сounter.widthAnchor.constraint(equalToConstant: 60),
			сounter.heightAnchor.constraint(equalToConstant: 40),
			сounter.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 10),
			сounter.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10),
		]
	}()

	public lazy var collectionView: UICollectionView = {
		let viewLayout = UICollectionViewFlowLayout()
		viewLayout.scrollDirection = .vertical
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = DefaultStyle.Colors.background
		return collectionView
	}()

	private lazy var сounter: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = DefaultStyle.Fonts.system15
		label.numberOfLines = 1
		label.textAlignment = .center
		label.isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
}
