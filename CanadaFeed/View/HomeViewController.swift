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

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.dataSource = dataSource
		tableView.tableFooterView = UIView()
		fetchFeed()
    }

	func fetchFeed() {
		viewModel.fetchFeedData(refresh: true) { [weak self] _, _ in
			guard let this = self else {
				return
			}
			this.tableView.reloadData()
		}
	}
}

// MARK: - UITableViewDelegates

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
}
