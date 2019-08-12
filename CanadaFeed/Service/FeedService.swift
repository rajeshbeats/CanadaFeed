//
//  FeedService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation
import Alamofire

struct AppError: LocalizedError {
	let errorDescription: String?

	static let unknownError = AppError(errorDescription: "Unknown Error")
	static let apiEndpointError = AppError(errorDescription: "API endpoint not found")
	static let networkError = AppError(errorDescription: "Network or data error")
}

fileprivate extension Constant {
	enum AppUrl: String {
		case feed = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
	}
}

typealias FetchCompletion = (FeedList?, Error?) -> Void

struct FeedService {
	static func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			completion(nil, AppError.apiEndpointError)
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.cachePolicy = refresh ? .reloadIgnoringLocalAndRemoteCacheData : .returnCacheDataElseLoad
		//let data = URLCache.shared.cachedResponse(for: urlRequest)

		Alamofire.request(urlRequest).responseData { dataResponse in

			switch dataResponse.result {
			case .success(let value):
				guard let data = value.toUtf8  else {
					debugPrint("Unable to convert response data into utf8")
					completion(nil, AppError.networkError)
					return
				}

				do {
					let list = try JSONDecoder().decode(FeedList.self, from: data)
					completion(list, nil)
				} catch {
					completion(nil, nil)
					debugPrint("JSONDecoder Error: \(error)")
					completion(nil, AppError.networkError)
				}

			case .failure(let error):
				debugPrint("Error: \(error)")
				completion(nil, AppError.networkError)
			}
		}
	}
}
