//
//  HomeViewController.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	let dataSource = HomeListDataSource()
	lazy var  viewModel: HomeViewModelProtocol = {
		return HomeViewModel(listDataSource: dataSource)
	}()
	var completionHandler: FetchCompletion?

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = dataSource
		tableView.tableFooterView = UIView()
		tableView.estimatedRowHeight = 45
		tableView.rowHeight = UITableView.automaticDimension
		fetchFeed()
    }

	func fetchFeed() {
		completionHandler = { [weak self] _, _ in
			guard let this = self else {
				return
			}
			this.tableView.reloadData()
		}

		viewModel.fetchFeedData(refresh: true, completion: completionHandler)

	}
}

// MARK: - UITableViewDelegates

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == 0 && indexPath.section == 1 && !viewModel.isFetchInProgress {
			viewModel.fetchFeedData(refresh: false, completion: completionHandler)
		}
	}
}
