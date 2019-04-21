//
//  ImageFilterType.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

enum ImageFilterType {
    case rotate
    case invert
    case mirror
    
    var description: String {
        switch self {
        case .rotate:
            return "rotate"
        case .invert:
            return "invert"
        case .mirror:
            return "mirror"
        }
    }
    
    var processingName: String {
        switch self {
        case .rotate:
            return "rotating"
        case .invert:
            return "inverting color"
        case .mirror:
            return "mirroring"
        }
    }
}
