//
//  Router.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

class Router {
	private enum State {
		case base
	}

	init() {}

	private lazy var viewController: UINavigationController = {
		let viewModel = SearchViewModelImpl(router: self)
		let searchViewController = SearchViewController(viewModel: viewModel)
		return UINavigationController(rootViewController: searchViewController)
	}()

	public func rootViewController() -> UINavigationController {
		viewController
	}
}
