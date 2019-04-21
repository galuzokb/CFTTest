//
//  Constants.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit


struct Constants {
    
    struct URLs {
        static let exampleImage = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtFJ8O669E1dN4krsFowlbx3GiQ6-lOm2GbJr2BXqaPUZjgrKm"
    }
    
    struct Color {
        static let main = UIColor(red: 210.0 / 255.0, green: 90.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    
    struct Font {
        static func system(ofSize size: CGFloat) -> UIFont {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
