//
//  SearchViewModel.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 07.07.2021.
//

import Foundation
import UIKit

protocol SearchViewModel: AnyObject {
	var searchBegin: () -> Void { get set }
	var searchComplete: ([iTunesItem], Int) -> Void { get set }
	var searchClear: () -> Void { get set }
	var showMessage: (Bool, String) -> Void { get set }

	func start()

	func checkForUpdate(_ index: Int) -> Bool
	func checkForSearch(_ text: String) -> Bool
	func search(_ text: String)
	func update()

	func toPreview(_ index: Int)
}
