//
//  Constant.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

/// Application constants
struct Constant {
	static let appName = "Canada Feed"

	/// Messages
	struct Message {
		static let descriptionNotAvailable = "Description not available"
		static let titleNotAvailable = "Title not available"
	}

	/// App endpoint URLS
	///
	/// - feed: Canda Feed url
	enum AppUrl: String {
		case feed = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
	}
}

/// App specific error
struct AppError: LocalizedError {
	let errorDescription: String?

	/// Unknown error case
	static let unknownError = AppError(errorDescription: "Unknown Error")

	/// API endpoint not available error
	static let apiEndpointError = AppError(errorDescription: "API endpoint not found")

	/// Network related error
	static let networkError = AppError(errorDescription: "Unable to perform data refresh, please try again later")
}
