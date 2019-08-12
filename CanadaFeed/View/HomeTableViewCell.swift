//
//  HomeTableViewCell.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!

	func update(_ feed: FeedData?) {
		descriptionLabel.text = feed?.details ?? Constant.Message.descriptionNotAvailable
		titleLabel.text = feed?.title ?? Constant.Message.titleNotAvailable
		iconImageView.loadImage(with: feed?.imageHref)
	}
}

class LoadingIndicatorCell: UITableViewCell {
	@IBOutlet weak var activitiIndicatorView: UIActivityIndicatorView!

	override func prepareForReuse() {
		super.prepareForReuse()
		activitiIndicatorView.startAnimating()
	}
}
