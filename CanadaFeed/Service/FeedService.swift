//
//  FeedService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

extension Constant {
	enum AppUrl: String {
		case feed = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
	}
}

protocol FeedServiceProtocol {
	func fetchFeed(index: Int, limit: Int, refresh: Bool, completion: @escaping FetchCompletion)
}

typealias FetchCompletion = (FeedList?, Error?) -> Void

struct FeedService: FeedServiceProtocol {

	static var session = URLSession(configuration: URLSessionConfiguration.default)

	func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			completion(nil, AppError.apiEndpointError)
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.cachePolicy = .returnCacheDataElseLoad
		FeedService.session.dataTask(with: urlRequest) { data, _, error in
			guard error == nil, let responseData = data  else {
				// Handle error if present or data empty.
				completion(nil, error ?? AppError.networkError)
				return
			}
			// Prepare response data.
			guard let data = responseData.toUtf8  else {
				debugPrint("Unable to convert response data into utf8")
				completion(nil, AppError.networkError)
				return
			}

			do {
				let list = try JSONDecoder().decode(FeedList.self, from: data)
				completion(list, nil)
			} catch {
				debugPrint("JSONDecoder Error: \(error)")
				completion(nil, AppError.networkError)
			}
		}.resume()
	}
}
