//
//  SearchService.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

typealias SearchResult = Result<iTunesList, SearchError>

protocol SearchService {
	func search(search: String, offset: Int, completion: @escaping (SearchResult) -> Void)
}
