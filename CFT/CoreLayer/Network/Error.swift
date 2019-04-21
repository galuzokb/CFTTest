//
//  Error.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

protocol BaseError: CustomNSError {
    
}

extension BaseError {
    static var errorDomain: String {
        return String(describing: type(of: self))
    }
    
    var errorCode: Int {
        return String(reflecting: self).hashValue
    }
}

class CFTError: BaseError {
    var code: Int = 0
    
    var message = "Unknown error"
    
    init(code: Int = 0, message: String = "Unknown error") {
        self.code = code
        self.message = message
    }
}

struct BDError: Error {
    var message: String = ""
    
    init(message: String) {
        self.message = message
    }
}

extension Error {
    func message() -> String {
        if let error = self as? CFTError {
            return error.message
        } else if let error = self as? BDError {
            return error.message
        }
        
        return self.localizedDescription
    }
}
