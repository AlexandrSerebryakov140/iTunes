//
//  SearchService.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

protocol SearchService {
	func beginSearch(search: String, offset: Int, completion: @escaping (Result<iTunesList, SearchError>) -> Void)
}

final class SearchServiceImpl: SearchService {
	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	public func beginSearch(
		search: String,
		offset: Int,
		completion: @escaping (Result<iTunesList, SearchError>) -> Void
	) {
		guard let request = searchRequest(search: search, offset: offset) else {
			completion(.failure(.request))
			return
		}

		session.dataTask(with: request, completionHandler: { data, _, error in

			if let requestError = error as NSError? {
				completion(.failure(.error(requestError)))
				return
			}

			guard let rdata = data else {
				completion(.failure(.responce))
				return
			}

			var list = iTunesList()

			do {
				list = try JSONDecoder().decode(iTunesList.self, from: rdata)
			} catch let decodeError as NSError {
				completion(.failure(.error(decodeError)))
				return
			}

			guard list.resultCount > 0 else {
				completion(offset > 0 ? .failure(.notUpdate) : .failure(.notFound(search)))
				return
			}

			completion(.success(list))

		}).resume()
	}

	private func searchRequest(search: String, offset: Int = 0) -> URLRequest! {
		let mainURL = "https://itunes.apple.com/search"
		let limit = offset == 0 ? 30 : 15

		func escapedSearch(search: String) -> String! {
			let params = search.replacingOccurrences(of: " ", with: "+")
			let characterSet = NSCharacterSet.urlQueryAllowed
			let escaped = params.addingPercentEncoding(withAllowedCharacters: characterSet)
			return escaped
		}

		func searchURL(escaped: String, offset: Int = 0) -> URL! {
			let path = "\(mainURL)?term=\(escaped)&limit=\(limit)&offset=\(offset)"
			return URL(string: path)
		}

		guard let escaped = escapedSearch(search: search) else { return nil }
		guard let url = searchURL(escaped: escaped, offset: offset) else { return nil }
		let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20)
		return request
	}
}
