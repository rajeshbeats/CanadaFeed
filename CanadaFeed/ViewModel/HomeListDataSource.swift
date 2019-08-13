//
//  HomeListDataSource.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

private extension Constant {
	struct CellIdentifier {
		static let homeCell = "HomeTableViewCell"
		static let loadingCell = "LoadingIndicatorCell"
	}
}

protocol HomeListDataSourceProtocol: UITableViewDataSource {

	/// Array of FeedData items
	var data: [FeedData] { get set }

	/// Max limit for result
	var maxLimit: Int { get set }
}

class HomeListDataSource: NSObject, HomeListDataSourceProtocol {
	var data: [FeedData] = []
	// limit set to max for showing infinity scroll
	var maxLimit: Int = Int.max
}

extension HomeListDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return data.count < maxLimit && data.count != 0 ? 2 : 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? data.count : 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard indexPath.section == 0 else {
			let cell: LoadingIndicatorCell = tableView.dequeueGenericCell(identifier: Constant.CellIdentifier.loadingCell, for: indexPath)
			return cell
		}
		let cell: HomeTableViewCell = tableView.dequeueGenericCell(identifier: Constant.CellIdentifier.homeCell, for: indexPath)
		cell.update(data[indexPath.row])
		return cell
	}
}
