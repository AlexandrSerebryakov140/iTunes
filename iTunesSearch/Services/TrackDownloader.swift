//
//  TrackDownloader.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 18.07.2021.
//

import Foundation

class TrackDownloader: NSObject, URLSessionDownloadDelegate {
	lazy var session: URLSession = {
		let queue = OperationQueue()
		return URLSession(configuration: .default, delegate: self, delegateQueue: queue)
	}()

	typealias Completion2 = (Result<URL, FileDownloadError>) -> Void
	typealias Progress = (_ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void

	public var progressUpdate: Progress = { _, _ in }
	public var completionHandler: Completion2 = { _ in }

	public func download(previewURL: String, completion: @escaping Completion2, progress: @escaping Progress) {
		guard let url = URL(string: previewURL) else {
			completion(.failure(.url))
			return
		}

		progressUpdate = progress
		completionHandler = completion

		let request = URLRequest(url: url)
		session.downloadTask(with: request).resume()
	}

	public func download(previewURL: String) {
		guard let url = URL(string: previewURL) else {
			completionHandler(.failure(.url))
			return
		}

		let request = URLRequest(url: url)
		session.downloadTask(with: request).resume()
	}

	internal func urlSession(
		_: URLSession,
		downloadTask _: URLSessionDownloadTask,
		didFinishDownloadingTo location: URL
	) {
		print("Файл успешно скачан")
		completionHandler(.success(location))
	}

	internal func urlSession(
		_: URLSession,
		task _: URLSessionTask,
		didCompleteWithError error: Error?
	) {
		if error != nil {
			print("Ошибка закачки файла:" + (error?.localizedDescription)!)
			completionHandler(.failure(error as! FileDownloadError))
		} else {
			print("Выполнено")
		}
	}

	internal func urlSession(
		_: URLSession,
		downloadTask _: URLSessionDownloadTask,
		didWriteData _: Int64,
		totalBytesWritten: Int64,
		totalBytesExpectedToWrite: Int64
	) {
		progressUpdate(totalBytesWritten, totalBytesExpectedToWrite)
	}
}
