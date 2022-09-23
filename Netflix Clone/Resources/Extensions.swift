//
//  Extensions.swift
//  Netflix Clone
//
//  Created by PethaniSmit on 23/09/22.
//

import Foundation

extension String{
    func capitalizeFirstLatter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
