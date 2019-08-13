//
//  FeedService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

protocol FeedServiceProtocol {
	static var session: URLSession { get set }
	func fetchFeed(index: Int, limit: Int, refresh: Bool, completion: @escaping FetchCompletion)
}

typealias FetchCompletion = (FeedList?, Error?) -> Void

class FeedService: FeedServiceProtocol {

	static var session = URLSession(configuration: URLSessionConfiguration.default)

	func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			completion(nil, AppError.apiEndpointError)
			return
		}
		var urlRequest = URLRequest(url: url)

		urlRequest.cachePolicy = refresh ? .reloadIgnoringLocalAndRemoteCacheData : .returnCacheDataElseLoad
		FeedService.session.dataTask(with: urlRequest) { [weak self] data, _, error in
			guard let this = self else {
				return
			}
			guard error == nil, let responseData = data  else {
				this.handleNetworkError(error ?? AppError.networkError, request: urlRequest, callback: completion)
				return
			}
			this.handleResponseData(responseData, callback: completion)
		}.resume()
	}
}

private extension FeedService {
	func handleResponseData(_ data: Data, callback: @escaping FetchCompletion) {
		guard let utf8Data = data.toUtf8  else {
			debugPrint("Unable to convert response data into utf8")
			callback(nil, AppError.networkError)
			return
		}
		do {
			let list = try JSONDecoder().decode(FeedList.self, from: utf8Data)
			callback(list, nil)
		} catch {
			debugPrint("JSONDecoder Error: \(error)")
			callback(nil, AppError.networkError)
		}
	}

	func handleNetworkError(_ error: Error, request: URLRequest, callback: @escaping FetchCompletion) {
		guard let response = URLCache.shared.cachedResponse(for: request) else {
			callback(nil, error)
			return
		}
		handleResponseData(response.data, callback: callback)
	}
}
