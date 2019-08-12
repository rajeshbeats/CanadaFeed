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
	}
}

protocol HomeListDataSourceProtocol: UITableViewDataSource {
	var data: [FeedData] { get set }
	var maxLimit: Int { get set }
}

class HomeListDataSource: NSObject, HomeListDataSourceProtocol {
	var data: [FeedData] = []
	var maxLimit: Int = 0
}

extension HomeListDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellIdentifier.homeCell, for: indexPath) as? HomeTableViewCell else {
			fatalError("Unable to load HomeTableViewCell")
		}
		cell.update(data[indexPath.row])
		return cell
	}
}
