//
//  FeedData.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

struct FeedData: Codable {
	let title: String?
	let details: String?
	let imageHref: String?

	enum CodingKeys: String, CodingKey {
		case title
		case details = "description"
		case imageHref
	}
}

struct FeedList: Codable {
	let title: String?
	let rows: [FeedData]?
}
