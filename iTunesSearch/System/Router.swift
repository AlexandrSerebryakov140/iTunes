//
//  Router.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

class Router {
	private let session: URLSession
	private let imageService: ImageService
	private let searchService: SearchService

	init() {
		let queue = OperationQueue()
		session = URLSession(configuration: .default, delegate: nil, delegateQueue: queue)
		let cache = ImageCache()
		imageService = ImageServiceImpl(session: session, imageCache: cache)
		searchService = SearchServiceImpl(session: session, decoder: JSONDecoder())
	}

	private lazy var viewController: UINavigationController = {
		let viewModel = SearchViewModelImpl(router: self, searchService: searchService)
		let adapter = SearchCollectionAdapter(imageService: imageService)
		let searchViewController = SearchViewController(viewModel: viewModel, adapter: adapter)
		return UINavigationController(rootViewController: searchViewController)
	}()

	public func rootViewController() -> UINavigationController {
		viewController
	}

	public func toPreview(item: iTunesItem) {
		let downloadService = DownloadServiceImpl()
		let model = PreviewViewModelImpl(router: self, imageService: imageService, downloader: downloadService, item: item)
		let controller = PreviewViewController(viewModel: model, layout: PreviewViewControllerLayout())
		viewController.pushViewController(controller, animated: true)
	}
}
