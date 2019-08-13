//
//  FeedService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

protocol FeedServiceProtocol {

	/// URLSession
	static var session: URLSession { get set }

	/// Fetch feed data
	///
	/// - Parameters:
	///   - index: Start index - Int - For future reference
	///   - limit: Max limit per result - Int - For future reference
	///   - refresh: Refresh status
	///   - completion: FetchCompletion callback closure
	/// - Returns: nil
	func fetchFeed(index: Int, limit: Int, refresh: Bool, completion: @escaping FetchCompletion)
}

/// Completion closure
typealias FetchCompletion = (FeedList?, Error?) -> Void

class FeedService: FeedServiceProtocol {

	static var session = URLSession(configuration: URLSessionConfiguration.default)

	func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			completion(nil, AppError.apiEndpointError)
			return
		}
		var urlRequest = URLRequest(url: url)
		// Define cache policy based in refresh status
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

	/// Handle response data
	///
	/// - Parameters:
	///   - data: Data
	///   - callback: FetchCompletion
	func handleResponseData(_ data: Data, callback: @escaping FetchCompletion) {

		/// Convert data to utf8 because response contains ascii supported texts
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

	/// Handle networ error cases
	///
	/// - Parameters:
	///   - error: Error
	///   - request: URLRequest
	///   - callback: FetchCompletion
	func handleNetworkError(_ error: Error, request: URLRequest, callback: @escaping FetchCompletion) {

		/// Checkc for cached response
		guard let response = URLCache.shared.cachedResponse(for: request) else {
			callback(nil, error)
			return
		}
		handleResponseData(response.data, callback: callback)
	}
}
