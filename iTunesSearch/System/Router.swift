//
//  Router.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

class Router {
	private let imageService: ImageService
	private let searchService: SearchService

	private enum State {
		case base
	}

	init() {
		let session = URLSession(configuration: .default)
		imageService = ImageServiceImpl(session: session, imageCache: ImageCache())
		searchService = SearchServiceImpl(session: session)
	}

	private lazy var viewController: UINavigationController = {
		let viewModel = SearchViewModelImpl(router: self, searchService: searchService, imageService: imageService)
		let searchViewController = SearchViewController(viewModel: viewModel)
		return UINavigationController(rootViewController: searchViewController)
	}()

	public func rootViewController() -> UINavigationController {
		viewController
	}
}
