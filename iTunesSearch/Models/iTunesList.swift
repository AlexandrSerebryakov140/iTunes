//
//  iTunesList.swift
//  iTunesSearchSwift
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

public struct iTunesList: Codable {
	var resultCount: Int
	var results: [iTunesItem]

	private enum CodingKeys: String, CodingKey {
		case resultCount
		case results
	}

	init() {
		resultCount = 0
		results = []
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.resultCount = try container.decode(Int.self, forKey: .resultCount)
		self.results = try container.decode([iTunesItem].self, forKey: .results)
	}
}
