//
//  SearchService.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

typealias SearchResult = Result<iTunesList, SearchError>

protocol SearchService {
	func search(
		search: String,
		offset: Int,
		completion: @escaping (SearchResult) -> Void
	)
}

final class SearchServiceImpl: SearchService {
	private let session: URLSession

	init(session: URLSession) {
		self.session = session
	}

	public func search(
		search: String,
		offset: Int,
		completion: @escaping (SearchResult) -> Void
	) {
		guard let request = searchRequest(search: search, offset: offset) else {
			completion(.failure(.request))
			return
		}

		session.dataTask(with: request, completionHandler: { data, _, error in
			let result = self.checkResult(responceData: data, error: error as NSError?, search: search, offset: offset)
			completion(result)

		}).resume()
	}

	private func checkResult(responceData: Data?, error: NSError?, search: String, offset: Int) -> SearchResult {
		if let requestError = error {
			return .failure(.error(requestError))
		}

		guard let data = responceData, !data.isEmpty else {
			return .failure(.responce)
		}

		var list = iTunesList()

		do {
			list = try iTunesList.create(data: data)
		} catch let decodeError as NSError {
			return .failure(.error(decodeError))
		}

		print(list)

		guard list.resultCount > 0 else {
			return .failure(offset > 0 ? .notUpdate : .notFound(search))
		}

		return .success(list)
	}

	private func searchRequest(search: String, offset: Int = 0) -> URLRequest! {
		let mainURL = "https://itunes.apple.com/search"
		let limit = offset == 0 ? 30 : 15
		let policy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData

		func escapedSearch(search: String) -> String! {
			let params = search.replacingOccurrences(of: " ", with: "+")
			let characterSet = NSCharacterSet.urlQueryAllowed
			let escaped = params.addingPercentEncoding(withAllowedCharacters: characterSet)
			return escaped
		}

		func searchURL(escaped: String, offset _: Int = 0) -> URL! {
			let path = "\(mainURL)?term=\(escaped)&limit=\(limit)&offset=\(offset)"
			return URL(string: path)
		}

		guard let escaped = escapedSearch(search: search) else { return nil }
		guard let url = searchURL(escaped: escaped, offset: offset) else { return nil }
		let request = URLRequest(url: url, cachePolicy: policy, timeoutInterval: 20)

		print(url)

		return request
	}
}
