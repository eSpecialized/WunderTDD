//
//  String+URLComponents.swift
//  WunderTDD
//
//  Created by William Thompson on 1/25/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import Foundation

extension String {
    /**
     This function extends String allowing to separate into an Optional Array of Strings the URL Path.
     
     - parameters:
        - separator: What the separator should be. Defaults to forward slash /.
     
     - returns: An [String]? array of the Path components.
     
     */
    public func urlPathComponentsFromString(separator: String = "/") -> [String]? {
        return URLComponents(string: self)?.path.components(separatedBy: CharacterSet(charactersIn: separator))
    }
}

