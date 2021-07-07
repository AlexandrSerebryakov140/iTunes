//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation

protocol SearchViewModel: AnyObject {
	func start(presenter: SearchViewController)
	func search(_ text: String)
	func count() -> Int
}

final class SearchViewModelImpl: SearchViewModel {
	private let router: Router

	init(router: Router) {
		self.router = router
	}

	public func count() -> Int {
		15
	}

	func start(presenter _: SearchViewController) {}

	func search(_: String) {}
}
