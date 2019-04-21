//
//  RoundedButton.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

@IBDesignable
public class RoundedButton: UIButton {
    
    @IBInspectable
    public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    public var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable
    public var adjustFontToFit: Bool = false {
        didSet { configure() }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        self.titleLabel?.adjustsFontSizeToFitWidth = adjustFontToFit
    }
}

