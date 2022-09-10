//
//  ImageService.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import UIKit

protocol ImageService {
	func download(
		path: String?,
		completion: @escaping (_ image: UIImage, _ path: String) -> Void,
		failure: @escaping (_ error: ImageServiceError) -> Void
	)
}
