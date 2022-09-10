//
//  DownloadService.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

protocol DownloadService {
	typealias Completion = (Result<URL, DownloadServiceError>) -> Void
	typealias DownloadProgress = (_ total: Int64, _ totalExpected: Int64) -> Void

	var progressUpdate: DownloadProgress { get set }
	var completionHandler: Completion { get set }
	func download(previewURL: String, completion: @escaping Completion, progress: @escaping DownloadProgress)
	func download(previewURL: String)
	func cancelDownload(previewURL: String)
}
