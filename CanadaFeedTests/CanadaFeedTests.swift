//
//  CanadaFeedTests.swift
//  CanadaFeedTests
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import XCTest
@testable import CanadaFeed

class CanadaFeedTests: XCTestCase {

	let url = URL(string: Constant.AppUrl.feed.rawValue)!

	override func setUp() {
		// Setup URLSession for mockup and testing
		URLCache.shared.removeAllCachedResponses()
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [URLMockProtocol.self]
		let session = URLSession(configuration: config)
		FeedService.session = session
	}

	/// Test valid response
	func testProperResponse() {
		URLMockProtocol.testURLs = [url: Data(MockResponse.validResponse.utf8)]
		let testExpectation = expectation(description: "Successful response from endpoint")

		let service = FeedService()
		let dataSource = HomeListDataSource()
		let viewModel = HomeViewModel(listDataSource: dataSource)
		viewModel.service = service

		viewModel.fetchFeedData(refresh: true) { list, error in
			XCTAssert(error == nil, "Unexpected error occurred")
			XCTAssert(list?.rows?.count == 2, "Feed list count not matching")
			XCTAssert(viewModel.feed(for: 0)?.title == "Beavers", "Data source info mismatch")
			testExpectation.fulfill()
		}
		wait(for: [testExpectation], timeout: 5)
	}

	/// Test invalid response
	func testInvalidResponse() {
		URLMockProtocol.testURLs = [url: Data(MockResponse.invalidResponse.utf8)]
		let testExpectation = expectation(description: "Error handling")

		let service = FeedService()
		let dataSource = HomeListDataSource()
		let viewModel = HomeViewModel(listDataSource: dataSource)
		viewModel.service = service
		viewModel.fetchFeedData(refresh: true) { list, error in
			XCTAssert(error != nil, "Expecting error")
			XCTAssert(list == nil, "Feed list should be nil")
			testExpectation.fulfill()
		}
		wait(for: [testExpectation], timeout: 5)
	}

	/// Test response appending scenario
	func testResponseAppending() {
		URLMockProtocol.testURLs = [url: Data(MockResponse.validResponse.utf8)]
		let testExpectation = expectation(description: "Successful response appending")

		let service = FeedService()
		let dataSource = HomeListDataSource()
		let viewModel = HomeViewModel(listDataSource: dataSource)
		viewModel.service = service
		viewModel.fetchFeedData(refresh: true) { _, _ in
			viewModel.fetchFeedData(refresh: false, completion: { _, _ in
				XCTAssert(dataSource.data.count == 4, "Feed list count not matching")
				testExpectation.fulfill()
			})
		}
		wait(for: [testExpectation], timeout: 5)
	}

	/// Test API error
	func testAPIError() {
		URLMockProtocol.testURLs = [url: nil]
		let testExpectation = expectation(description: "Expecting API error from service")
		let service = FeedService()
		let dataSource = HomeListDataSource()
		let viewModel = HomeViewModel(listDataSource: dataSource)
		viewModel.service = service
		viewModel.fetchFeedData(refresh: true) { list, error in
			XCTAssert(error != nil, "Expecting error")
			XCTAssert(list == nil, "Feed list should be nil")
			testExpectation.fulfill()
		}
		wait(for: [testExpectation], timeout: 5)
	}

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
