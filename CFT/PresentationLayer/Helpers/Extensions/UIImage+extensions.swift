//
//  UIImage+extensions.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

struct ImageTransfromParameters {
    let scaleX: CGFloat
    let scaleY:CGFloat
    
    let translateX: CGFloat
    let translateY: CGFloat
    
    let rotation: CGFloat
    
    let width: CGFloat
    let height: CGFloat
}

extension UIImage {
    /// ImageTransformParameters for rotate filter
    var rotateParameters: ImageTransfromParameters {
        var scaleX: CGFloat
        var scaleY:CGFloat
        
        var translateX: CGFloat
        var translateY: CGFloat
        
        var rotation: CGFloat
        
        var width: CGFloat
        var height: CGFloat
        
        switch imageOrientation {
        case .down, .downMirrored:
            scaleX = size.width / size.height
            scaleY = size.height / size.width
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 1.5)
            translateX = 0.0
            translateY = size.width
        case .up, .upMirrored:
            scaleX = size.width / size.height
            scaleY = size.height / size.width
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 0.5)
            translateX = size.height
            translateY = 0.0
        case .left, .leftMirrored:
            scaleX = size.height / size.width
            scaleY = size.width / size.height
            width = size.width
            height = size.height
            rotation = CGFloat(Double.pi)
            translateX = size.height
            translateY = size.width
        case .right, .rightMirrored:
            scaleX = size.height / size.width
            scaleY = size.width / size.height
            width = size.width
            height = size.height
            rotation = 0.0
            translateX = 0.0
            translateY = 0.0
        @unknown default:
            fatalError("beda")
        }
        
        return ImageTransfromParameters(
            scaleX: scaleX,
            scaleY: scaleY,
            translateX: translateX,
            translateY: translateY,
            rotation: rotation,
            width: width,
            height: height
        )
    }
    
    /// ImageTransformParameters for invert filter
    var invertParameters: ImageTransfromParameters {
        
        var translateX: CGFloat
        var translateY: CGFloat
        
        var rotation: CGFloat
        
        var width: CGFloat
        var height: CGFloat
        
        switch imageOrientation {
        case .down, .downMirrored:
            width = size.width
            height = size.height
            rotation = CGFloat(Double.pi)
            translateX = size.width
            translateY = size.height
        case .up, .upMirrored:
            width = size.width
            height = size.height
            rotation = 0.0
            translateX = 0.0
            translateY = 0.0
        case .left, .leftMirrored:
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 0.5)
            translateX = size.width
            translateY = 0.0
        case .right, .rightMirrored:
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 1.5)
            translateX = 0.0
            translateY = size.height
        @unknown default:
            fatalError("beda")
        }
        
        return ImageTransfromParameters(
            scaleX: scale,
            scaleY: scale,
            translateX: translateX,
            translateY: translateY,
            rotation: rotation,
            width: width,
            height: height
        )
    }
    
    /// ImageTransformParameters for mirror filter
    var mirrorParameters: ImageTransfromParameters {
        var translateX: CGFloat
        var translateY: CGFloat
        
        var rotation: CGFloat
        
        var width: CGFloat
        var height: CGFloat
        
        switch imageOrientation {
        case .down, .downMirrored:
            width = size.width
            height = size.height
            rotation = CGFloat(Double.pi)
            translateX = 0.0
            translateY = size.height
        case .up, .upMirrored:
            width = size.width
            height = size.height
            rotation = 0.0
            translateX = size.width
            translateY = 0.0
        case .left, .leftMirrored:
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 1.5)
            translateX = 0.0
            translateY = 0.0
        case .right, .rightMirrored:
            width = size.height
            height = size.width
            rotation = CGFloat(Double.pi * 0.5)
            translateX = size.width
            translateY = size.height
        @unknown default:
            fatalError("beda")
        }
        
        return ImageTransfromParameters(
            scaleX: -scale,
            scaleY: scale,
            translateX: translateX,
            translateY: translateY,
            rotation: rotation,
            width: width,
            height: height
        )
    }
}
