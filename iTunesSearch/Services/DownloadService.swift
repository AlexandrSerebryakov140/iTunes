//
//  TrackDownloader.swift
//  iTunesSearch
//
//  Created by Alexandr Serebryakov on 18.07.2021.
//

import Foundation

protocol DownloadService {
	typealias Completion = (Result<URL, FileDownloadError>) -> Void
	typealias DownloadProgress = (_ total: Int64, _ totalExpected: Int64) -> Void

	var progressUpdate: DownloadProgress { get set }
	var completionHandler: Completion { get set }
	func download(previewURL: String, completion: @escaping Completion, progress: @escaping DownloadProgress)
	func download(previewURL: String)
}

class DownloadServiceImpl: NSObject, DownloadService, URLSessionDownloadDelegate {
	lazy var session: URLSession = {
		let queue = OperationQueue()
		return URLSession(configuration: .default, delegate: self, delegateQueue: queue)
	}()

	public var progressUpdate: DownloadProgress = { _, _ in }
	public var completionHandler: Completion = { _ in }

	public func download(previewURL: String, completion: @escaping Completion, progress: @escaping DownloadProgress) {
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

	// MARK: - URLSessionDownloadDelegate

	internal func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		print("Файл успешно скачан")
		completionHandler(.success(location))
	}

	internal func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
		guard let err = error else { return }
		print("Ошибка закачки файла: \(err.localizedDescription)")
		completionHandler(.failure(err as! FileDownloadError))
	}

	internal func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		progressUpdate(totalBytesWritten, totalBytesExpectedToWrite)
	}
}
