//
//  Constant.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

struct Constant {
	static let appName = "Canada Feed"

	struct Message {
		static let descriptionNotAvailable = "Description not available"
		static let titleNotAvailable = "Title not available"
	}

	enum AppUrl: String {
		case feed = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
	}
}

struct AppError: LocalizedError {
	let errorDescription: String?
	static let unknownError = AppError(errorDescription: "Unknown Error")
	static let apiEndpointError = AppError(errorDescription: "API endpoint not found")
	static let networkError = AppError(errorDescription: "Unable to perform data refresh, please try again later")
}
