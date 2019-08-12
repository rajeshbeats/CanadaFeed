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
	var data: [FeedData] { get set }
	var maxLimit: Int { get set }
}

class HomeListDataSource: NSObject, HomeListDataSourceProtocol {
	var data: [FeedData] = []
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
		if indexPath.section == 1 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.loadingCell, for: indexPath) as? LoadingIndicatorCell else {
				fatalError("Unable to load LoadingIndicatorCell")
			}
			cell.selectionStyle = .none
			return cell
		}
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.homeCell, for: indexPath) as? HomeTableViewCell else {
			fatalError("Unable to load HomeTableViewCell")
		}
		cell.update(data[indexPath.row])
		return cell
	}
}
