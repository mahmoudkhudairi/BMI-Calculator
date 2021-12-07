//
//  String.swift
//  localeBMI
//
//  Created by mahmoudkhudairi on 07/12/2021.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
