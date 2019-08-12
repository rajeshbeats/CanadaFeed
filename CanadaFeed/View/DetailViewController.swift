//
//  DetailViewController.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var topview: UIView!
	var feed: FeedData?

    override func viewDidLoad() {
        super.viewDidLoad()
		imageView.loadImage(with: feed?.imageHref)
		titleLabel.text = feed?.title ?? Constant.Message.titleNotAvailable
    }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	@IBAction func dismissScreen() {
		dismiss(animated: true, completion: nil)
	}
}
