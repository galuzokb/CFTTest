//
//  URL+extensions.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

extension URL {
    var isValid: Bool {
        return UIApplication.shared.canOpenURL(self)
    }
}
