//
//  String+URLComponents.swift
//  WunderTDD
//
//  Created by William Thompson on 1/25/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import Foundation

extension String {
    func urlPathComponentsFromString(separator: String) -> [String]? {
        return URLComponents(string: self)?.path.components(separatedBy: CharacterSet(charactersIn: separator))
    }
}

