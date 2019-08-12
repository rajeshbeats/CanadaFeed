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

typealias FetchCompletion = (FeedList?) -> Void

struct FeedService {
	static func fetchFeed(index: Int, limit: Int, refresh: Bool = false, completion: @escaping FetchCompletion) {
		guard let url = URL(string: Constant.AppUrl.feed.rawValue) else {
			return
		}
		var urlRequest = URLRequest(url: url)
		urlRequest.cachePolicy = refresh ? .reloadIgnoringLocalAndRemoteCacheData : .returnCacheDataElseLoad

		Alamofire.request(urlRequest).responseData { dataResponse in

			switch dataResponse.result {
			case .success(let value):
				guard let data = value.toUtf8  else {
					completion(nil)
					return
				}
				do {
					let list = try JSONDecoder().decode(FeedList.self, from: data)
					completion(list)
				} catch {
					completion(nil)
					debugPrint("JSONDecoder Error: \(error)")
				}
			case .failure(let error):
				debugPrint("Error: \(error)")
				completion(nil)
			}
		}
	}
}
