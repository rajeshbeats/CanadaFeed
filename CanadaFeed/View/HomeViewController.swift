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
	lazy var refreshControl: UIRefreshControl = {
		return UIRefreshControl()
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = dataSource
		tableView.estimatedRowHeight = 70
		tableView.tableFooterView = UIView()
		addRefreshControl()
		fetchListener()
		refreshAction()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard let indexPath = tableView.indexPathForSelectedRow else {
			return
		}
		tableView.deselectRow(at: indexPath, animated: true)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let viewController = segue.destination as? DetailViewController else {
			return
		}
		viewController.feed = viewModel.feed(for: tableView.indexPathForSelectedRow?.row)
	}

	/// Add refresh control for pull to refresh functionality
	private func addRefreshControl() {
		tableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
	}

	@objc func refreshAction() {
		refreshControl.beginRefreshing()
		fetchFeed()
	}
}

extension HomeViewController {
	func fetchFeed() {
		viewModel.fetchFeedData(refresh: true, completion: completionHandler)
	}

	func fetchListener() {
		completionHandler = { [weak self] list, error in

			guard let this = self else {
				return
			}
			DispatchQueue.main.async {
				this.tableView.reloadData()
				if this.refreshControl.isRefreshing {
					this.refreshControl.endRefreshing()
				}
				if list == nil, let feedError = error {
					this.showErrorMessage(feedError.localizedDescription)
				}
				this.title = list?.title
			}
		}
	}
}

// MARK: - UITableViewDelegates

extension HomeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}

	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == 0 && indexPath.section == 1 && !viewModel.isFetchInProgress {
			viewModel.fetchFeedData(refresh: false, completion: completionHandler)
		}
	}
}
