//
//  PlaceholderImageView.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

enum PIVImageType {
    case image
    case placeholder
}

@IBDesignable
class PlaceholderImageView: UIImageView {
    
    private var currentImageType: PIVImageType
    private var isInitCompleted = false
    private var isResetingPlaceholder = true
    
    private var _image: UIImage?
    
    public override init(frame: CGRect) {
        currentImageType = .placeholder
        super.init(frame: frame)
        isResetingPlaceholder = true
        image = UIImage(named: "placeholder")
        isInitCompleted = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        currentImageType = .placeholder
        super.init(coder: aDecoder)
        isResetingPlaceholder = true
        image = UIImage(named: "placeholder")
        isInitCompleted = true
    }
    
    override var image: UIImage? {
        didSet {
//            guard isInitCompleted else {
//                return
//            }
            if image != nil {
                if currentImageType == .placeholder {
                    if isResetingPlaceholder {
                        isResetingPlaceholder = false
                        return
                    }
                    _image = image
                    currentImageType = .image
                }
            } else {
                isResetingPlaceholder = true
                currentImageType = .placeholder
                _image = nil
                image = UIImage(named: "placeholder")
            }
        }
    }
    
    var nonPlaceholderImage: UIImage? {
        return currentImageType == .placeholder ? nil : image
    }
}
