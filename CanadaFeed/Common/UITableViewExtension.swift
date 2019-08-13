//
//  UITableViewExtension.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 13/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import UIKit

extension UITableView {
	/// Dequeue Generic UITableViewCell
	///
	/// - Parameters:
	///   - identifier: String
	///   - indexPath: IndexPath
	/// - Returns: Given generic cell type
	func dequeueGenericCell<T>(identifier: String, for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
			fatalError("Unable to load Cell")
		}
		return cell
	}
}
