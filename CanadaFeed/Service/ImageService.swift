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
	/// Place holder image
	static let PlaceholderImage = UIImage(named: "icon-placeholder")
}

private struct ImageService {

	/// Load image
	///
	/// - Parameters:
	///   - url: URL
	///   - placeholderImage: Optional UIImage
	///   - imageView: UIImageView
	static func loadImage(with url: URL, placeholderImage: UIImage?, imageView: UIImageView) {
		let options = ImageLoadingOptions(
			placeholder: placeholderImage
		)
		Nuke.loadImage(with: url, options: options, into: imageView)
	}

	/// Load image with url and completion handler
	///
	/// - Parameters:
	///   - url: URL
	///   - completion: (UIImage?) -> Void
	static func loadImage(with url: URL, completion: @escaping (UIImage?) -> Void) {
		ImagePipeline.shared.loadImage(with: url, progress: nil, completion: { response, _ in
			completion(response?.image)
		})
	}
}

extension UIButton {

	/// Load image with URL string
	///
	/// - Parameter url: Optional
	func loadImage(with url: String?) {
		guard let urlString = url, let imageUrl = URL(string: urlString) else {
			setImage(Constant.PlaceholderImage, for: .normal)
			return
		}
		ImageService.loadImage(with: imageUrl) { [weak self] image in
			guard let this = self else {
				return
			}
			this.setImage(image ?? Constant.PlaceholderImage, for: .normal)
		}
	}
}

extension UIImageView {
	/// Load image with url
	///
	/// - Parameter url: Optional String
	func loadImage(with url: String?) {
		guard let urlString = url, let imageUrl = URL(string: urlString) else {
			image = Constant.PlaceholderImage
			return
		}
		ImageService.loadImage(with: imageUrl, placeholderImage: Constant.PlaceholderImage, imageView: self)
	}
}
