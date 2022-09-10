//
//  DownloadServiceError.swift
//  iTunesSearch
//
//  Created by Alexandr on 14.08.2022.
//

import Foundation

public enum DownloadServiceError: Error, Equatable {
	case error(NSError)
	case url
	case cancelled
}
