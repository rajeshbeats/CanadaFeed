//
//  UIViewControllerExtension.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 13/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

extension UIViewController {
	/// Show alert with given message
	///
	/// - Parameter message: String value
	func showErrorMessage(_ message: String) {
		let alert = UIAlertController(title: Constant.appName, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
		present(alert, animated: true)
	}
}
