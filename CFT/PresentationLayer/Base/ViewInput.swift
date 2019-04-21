//
//  ViewInput.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

protocol ViewInput {
    func showError(_ errorMessage: String)
    func showMessage(_ message: String)
}
