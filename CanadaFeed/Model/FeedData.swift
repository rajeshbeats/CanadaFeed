//
//  FeedData.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

struct FeedData: Codable {

	/// Feed title
	let title: String?

	/// Detail description
	let details: String?

	/// Image url
	let imageHref: String?

	enum CodingKeys: String, CodingKey {
		case title
		case details = "description"
		case imageHref
	}
}

struct FeedList: Codable {

	/// Feed title
	let title: String?

	/// Feed items
	let rows: [FeedData]?
}
