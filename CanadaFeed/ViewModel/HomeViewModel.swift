//
//  HomeViewModel.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {

	var isFetchInProgress: Bool { get set }
	init(listDataSource: HomeListDataSource)
	func fetchFeedData(refresh: Bool, completion: FetchCompletion?)
	func feed(for index: Int?) -> FeedData?
}

class HomeViewModel: HomeViewModelProtocol {
	weak var dataSource: HomeListDataSource?
	var isFetchInProgress = false

	required init(listDataSource: HomeListDataSource) {
		dataSource = listDataSource
	}

	func feed(for index: Int?) -> FeedData? {
		guard let rowIndex = index else {
			return nil
		}
		return dataSource?.data[rowIndex]
	}

	func fetchFeedData(refresh: Bool, completion: FetchCompletion?) {
		isFetchInProgress = true
		FeedService.fetchFeed(index: 0, limit: 0, refresh: refresh) { [weak self] list, error in
			guard let this = self else {
				return
			}
			guard let dataList = list?.rows else {
				return
			}
			if refresh {
				this.dataSource?.data = dataList
			} else {
				this.dataSource?.data.append(contentsOf: dataList)
			}
			this.isFetchInProgress = false
			completion?(list, error)
		}
	}
}
