//
//  FeedService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation
import Alamofire

fileprivate extension Constant {
	enum AppUrl: String {
		case feed = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
	}
}

protocol FeedServiceProtocol {
	func fetchFeed(index: Int, limit: Int, refresh: Bool, completion: @escaping FetchCompletion)
}

typealias FetchCompletion = (FeedList?, Error?) -> Void

struct FeedService: FeedServiceProtocol {
	func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			completion(nil, AppError.apiEndpointError)
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.cachePolicy = .returnCacheDataElseLoad

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
