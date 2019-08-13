//
//  MockResponse.swift
//  CanadaFeedTests
//
//  Created by Ramachandrakurup, Rajesh on 13/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

struct MockResponse {
	// swiftlint:disable line_length
	static let validResponse = """
{"title":"About Canada","rows":[{"title":"Beavers","description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony","imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"},{"title":"Flag","description":null,"imageHref":"http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"}]}
"""

	static let invalidResponse = """
{"title":"About Canada","rows":[{"title":"Beavers","description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony","imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"}"title":"Flag","description":null,"imageHref":"http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"}]}
"""
	// swiftlint:enable line_length
}
