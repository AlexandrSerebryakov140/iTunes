//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

struct iTunesItem: Codable, Equatable, Hashable {
	var type: String?
	var wrapperType: String?
	var kind: String?
	var genreName: String?
	var country: String?
	var releaseDate: String?
	var description: String?
	var longDescription: String?
	var artistName: String?
	var collectionName: String?
	var trackName: String?
	var artistId: String?
	var collectionId: Int?
	var trackId: Int?
	var trackTimeMillis: Int?
	var trackCount: Int?
	var trackNumber: Int?
	var discCount: Int?
	var discNumber: Int?
	var artworkUrl100: String?
	var previewUrl: String?

	private enum CodingKeys: String, CodingKey {
		case type
		case wrapperType
		case kind
		case genreName = "primaryGenreName"
		case country
		case releaseDate
		case description
		case longDescription
		case artistName
		case collectionName = "collectionCensoredName"
		case trackName = "trackCensoredName"
		case collectionId, trackId, artistId
		case trackTimeMillis
		case trackCount
		case trackNumber
		case discCount
		case discNumber
		case artworkUrl100
		case previewUrl
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		artistId = try? container.decodeForString(forKey: .artistId)
		type = try? container.decode(String.self, forKey: .type)
		wrapperType = try? container.decode(String.self, forKey: .wrapperType)
		kind = try? container.decode(String.self, forKey: .kind)
		genreName = try? container.decode(String.self, forKey: .genreName)
		country = try? container.decode(String.self, forKey: .country)
		releaseDate = try? container.decode(String.self, forKey: .releaseDate)
		description = try? container.decode(String.self, forKey: .description)
		longDescription = try? container.decode(String.self, forKey: .longDescription)
		artistName = try? container.decode(String.self, forKey: .artistName)
		collectionName = try? container.decode(String.self, forKey: .collectionName)
		trackName = try? container.decode(String.self, forKey: .trackName)
		artworkUrl100 = try? container.decode(String.self, forKey: .artworkUrl100)
		previewUrl = try? container.decode(String.self, forKey: .previewUrl)
		collectionId = try? container.decode(Int.self, forKey: .collectionId)
		trackId = try? container.decode(Int.self, forKey: .trackId)
		trackTimeMillis = try? container.decode(Int.self, forKey: .trackTimeMillis)
		trackCount = try? container.decode(Int.self, forKey: .trackCount)
		trackNumber = try? container.decode(Int.self, forKey: .trackNumber)
		discCount = try? container.decode(Int.self, forKey: .discCount)
		discNumber = try? container.decode(Int.self, forKey: .discNumber)
	}
}

extension KeyedDecodingContainer {
	fileprivate func decodeForString(forKey key: KeyedDecodingContainer.Key) throws -> String {
		do {
			return try decode(String.self, forKey: key)
		} catch DecodingError.typeMismatch {
			let value = try decode(Int.self, forKey: key)
			return String(describing: value)
		}
	}
}

extension iTunesItem {
	// возвращает ссылку на обложку альбома в высоком разрешении
	var artworkUrl600: String {
		(artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600"))!
	}
}
