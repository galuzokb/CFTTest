//
//  ImageServiceType.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

protocol DownloadProgressObserver: class {
    func progressUpdated(_ progress: Float)
    func imageLoaded(image: UIImage?, error: Error?)
}

protocol ImageServiceType {
    /// Observer receives notifications about image download progress
    var downloadProgressObserver: DownloadProgressObserver? { get set }
    
    /// Rotates given image by 90 degrees left
    func rotate(_ image: UIImage, completion: @escaping (UIImage?) -> ())
    /// Inverts color to grayscale of given image
    func invert(_ image: UIImage, completion: @escaping (UIImage?) -> ())
    /// Mirrors given image
    func mirror(_ image: UIImage, completion: @escaping (UIImage?) -> ())
    
    /// Start image download
    func download(fromURL url: URL)
    
//    func download(fromURL url: URL, withCompletion completion: @escaping (UIImage?, Error?) -> ())
    
    /// Save given image to Photo Libarary
    func saveToLibrary(_ image: UIImage)
    
    /// Get all stored image filtering results
    func getHistory() -> [CFTImage]
    /// Save new image filtering result
    func saveNew(_ image: CFTImage)
    /// Delete given image filtering result
    func delete(_ image: CFTImage)
    /// Delete all stored image filtering results
    func clearHistory()
}
