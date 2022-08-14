//
//  iTunesItem.swift
//  iTunesSearchSwift
//
//  Created by Alexandr Serebryakov on 08.07.2021.
//

import Foundation

/**
    # Основная структура списка, получаемого из iTunesSearch
 */

public struct iTunesItem: Codable, Equatable, Hashable {
	let type: String?
	let wrapperType: String?
	let kind: String?
	let genreName: String?
	let country: String?
	let releaseDate: String?
	let description: String?
	let longDescription: String?
	let artistName: String?
	let collectionName: String?
	let trackName: String?
	let artistId: String?
	let collectionId: Int?
	let trackId: Int?
	let trackTimeMillis: Int?
	let trackCount: Int?
	let trackNumber: Int?
	let discCount: Int?
	let discNumber: Int?
	let artworkUrl100: String?
	let previewUrl: String?

	private enum CodingKeys: String, CodingKey {
		case type
		case wrapperType
		case kind
		case genreName = "primaryGenreName"
		case country
		case releaseDate
		case description = "shortDescription"
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
	/// Функция позволяет декодировать либо напрямую в строку либо переводить в строку цифры при получении типа Int
	/// # Notes: #
	/// Проблема парсера JSON в iOS состоит в том что строкой он считает только то, что в кавычках.
	/// И в случае получения artistId вместо "12345678" просто 12345678 данные не распарсятся.
	/// Данный метод позволяет это исправить
	fileprivate func decodeForString(forKey key: KeyedDecodingContainer.Key) throws -> String {
		do {
			return try decode(String.self, forKey: key)
		} catch DecodingError.typeMismatch {
			let value = try decode(Int.self, forKey: key)
			return String(describing: value)
		}
	}
}
