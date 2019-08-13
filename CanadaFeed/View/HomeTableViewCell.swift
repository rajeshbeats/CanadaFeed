//
//  HomeTableViewCell.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit


/// Home Cell Action protocols
protocol HomeCellActionProtocol: class {

	/// Selected cell from UITableViewCell
	///
	/// - Parameter cell: UITableViewCell
	func selectedCell(_ cell: UITableViewCell)
}

class HomeTableViewCell: UITableViewCell {

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!

	weak var cellAction: HomeCellActionProtocol?

	/// Update cell
	///
	/// - Parameter feed: Optional FeedData
	func update(_ feed: FeedData?) {
		descriptionLabel.text = feed?.details ?? Constant.Message.descriptionNotAvailable
		titleLabel.text = feed?.title ?? Constant.Message.titleNotAvailable
		// Lazy loading images in UIImageView
		iconImageView.loadImage(with: feed?.imageHref)
	}

	@IBAction func imageButtonAction() {
		cellAction?.selectedCell(self)
	}
}

/// Loading indicator cell
class LoadingIndicatorCell: UITableViewCell {

	@IBOutlet weak var activitiIndicatorView: UIActivityIndicatorView!

	override func prepareForReuse() {
		super.prepareForReuse()
		activitiIndicatorView.startAnimating()
	}
}
