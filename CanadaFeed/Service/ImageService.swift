//
//  ImageService.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation
import Nuke

fileprivate extension Constant {
	static let PlaceholderImage = UIImage(named: "icon-placeholder")
}

private struct ImageService {
	static func loadImage(with url: URL, placeholderImage: UIImage?, imageView: UIImageView) {

		let options = ImageLoadingOptions(
			placeholder: placeholderImage
		)
		Nuke.loadImage(with: url, options: options, into: imageView)
	}
}

extension UIImageView {

	func loadImage(with url: String?) {
		guard let urlString = url, let imageUrl = URL(string: urlString) else {
			image = Constant.PlaceholderImage
			return
		}
		ImageService.loadImage(with: imageUrl, placeholderImage: Constant.PlaceholderImage, imageView: self)
	}
}
