//
//  DataExtension.swift
//  CanadaFeed
//
//  Created by Ramachandrakurup, Rajesh on 12/8/19.
//  Copyright © 2019 My Company. All rights reserved.
//

import Foundation

extension Data {
	var toUtf8: Data? {
		guard let asciiText = String(data: self, encoding: .ascii) else {
			return nil
		}
		return asciiText.data(using: .utf8)
	}
}
