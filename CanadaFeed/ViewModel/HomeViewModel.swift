//
//  HomeViewModel.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {

	/// Fetch in progres status
	var isFetchInProgress: Bool { get set }

	/// Feed service object
	var service: FeedServiceProtocol? { get set }

	/// Home List DataSource
	var dataSource: HomeListDataSource? { get set }

	/// Initilise method for ViewModel
	///
	/// - Parameter listDataSource: HomeListDataSource
	init(listDataSource: HomeListDataSource)

	/// Fetch feed from service
	///
	/// - Parameters:
	///   - refresh: Refresh status - Bool
	///   - completion: Optional FetchCompletion
	/// - Returns: nil
	func fetchFeedData(refresh: Bool, completion: FetchCompletion?)

	/// Feed for given index
	///
	/// - Parameter index: Int value
	/// - Returns: Optional FeedData item
	func feed(for index: Int?) -> FeedData?
}

class HomeViewModel: HomeViewModelProtocol {
	weak var dataSource: HomeListDataSource?
	var isFetchInProgress = false
	var service: FeedServiceProtocol? = FeedService()

	/// Start Index and limit count variables are added for future referece while implementing pagination.
	var startIndex = 0, limitCount = 0

	required init(listDataSource: HomeListDataSource) {
		dataSource = listDataSource
	}

	func feed(for index: Int?) -> FeedData? {
		guard let rowIndex = index, (dataSource?.data.count ?? 0) > rowIndex else {
			return nil
		}
		return dataSource?.data[rowIndex]
	}

	func fetchFeedData(refresh: Bool, completion: FetchCompletion?) {
		isFetchInProgress = true
		service?.fetchFeed(index: startIndex, limit: limitCount, refresh: refresh) { [weak self] list, error in
			guard let this = self else {
				return
			}
			defer {
				this.isFetchInProgress = false
				completion?(list, error)
			}
			guard let dataList = list?.rows else {
				return
			}
			// Handle result list based on refresh data
			if refresh {
				this.dataSource?.data = dataList
			} else {
				this.dataSource?.data.append(contentsOf: dataList)
			}
		}
	}
}
