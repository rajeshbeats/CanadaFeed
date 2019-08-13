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

	// MARK: - Override function

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = dataSource
		tableView.estimatedRowHeight = 70
		tableView.tableFooterView = UIView()
		addRefreshControl()
		fetchListener()
		refreshAction()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
}

// MARK: - View functions

extension HomeViewController {

	/// Add refresh control for pull to refresh functionality
	private func addRefreshControl() {
		tableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
	}

	/// Pull to Refresh action
	@objc func refreshAction() {
		refreshControl.beginRefreshing()
		fetchFeed()
	}

	/// Fetch latest available feed
	private func fetchFeed() {
		viewModel.fetchFeedData(refresh: true, completion: completionHandler)
	}

	/// Completion handler for fetch callback
	private func fetchListener() {
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
		if cell.isKind(of: HomeTableViewCell.self) {
			(cell as? HomeTableViewCell)?.cellAction = self
		}

		// Perform pagination loading if the table reaches end and not other requests in progress.
		if indexPath.row == 0 && indexPath.section == 1 && !viewModel.isFetchInProgress {
			viewModel.fetchFeedData(refresh: false, completion: completionHandler)
		}
	}
}

extension HomeViewController: HomeCellActionProtocol {
	func selectedCell(_ cell: UITableViewCell) {
		let viewController: DetailViewController = UIStoryboard.viewController(with: "DetailViewController")
		viewController.feed = viewModel.feed(for: tableView.indexPath(for: cell)?.row)
		present(viewController, animated: true, completion: nil)
	}
}
