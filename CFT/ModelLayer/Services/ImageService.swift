//
//  ImageService.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit
import CoreImage

class ImageService {
    static let shared = ImageService()
    
    private var network: NetworkType
    private let database: DataBaseManagerType
    
    private weak var _downloadProgressObserver: DownloadProgressObserver?
    
    init() {
        database = DataBaseManager.shared
        
        network = Network.shared
        network.downloadTaskObserver = self
    }
    
    private func delayTime() -> Double {
//        return 0.0
        return Double.random(in: 5.0...30.0)
    }
}

extension ImageService: ImageServiceType {
    var downloadProgressObserver: DownloadProgressObserver? {
        get {
            return _downloadProgressObserver
        }
        set {
            _downloadProgressObserver = newValue
        }
    }
    
    // MARK : - Fiter methods
    
    func rotate(_ image: UIImage, completion: @escaping (UIImage?) -> ()) {
        guard let cgImage = image.cgImage, let colorSpace = cgImage.colorSpace else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delayTime()) {
            
            var outputImage: UIImage?
            
            // set 0 for bytesPerRow instead of cgImage.bytesPerRow to avoid error:
            // CGBitmapContextCreate: invalid data bytes/row: should be at least 5120 for 8 integer bits/component, 3 components, kCGImageAlphaNoneSkipLast.
            let context = CGContext(
                data: nil,
                width: Int(image.size.height),
                height: Int(image.size.width),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).rawValue
            )
            
            let transform = CGAffineTransform.identity
                .translatedBy(x: image.rotateParameters.translateX, y: image.rotateParameters.translateY)
                .rotated(by: image.rotateParameters.rotation)
                .scaledBy(x: image.rotateParameters.scaleX, y: image.rotateParameters.scaleY)
            
            context?.concatenate(transform)
            
            context?.draw(cgImage, in: CGRect(x: 0,
                                              y: 0,
                                              width: image.rotateParameters.width,
                                              height: image.rotateParameters.height))
            
            if let newCGImage = context?.makeImage() {
                outputImage = UIImage(cgImage: newCGImage)
            }
            
            DispatchQueue.main.async {
                completion(outputImage)
            }
        }
    }
    
    func invert(_ image: UIImage, completion: @escaping (UIImage?) -> ()) {
        guard
            let cgImage = image.cgImage,
            let colorSpace = cgImage.colorSpace,
            let filter = CIFilter(name: "CIPhotoEffectMono")
        else {
            completion(nil)
            return
        }
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delayTime()) {
            var outputImage: UIImage?
            
            let context = CGContext(
                data: nil,
                width: Int(image.size.width),
                height: Int(image.size.height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).rawValue
            )
            
            let transform = CGAffineTransform.identity
                .translatedBy(x: image.invertParameters.translateX, y: image.invertParameters.translateY)
                .rotated(by: image.invertParameters.rotation)
            
            context?.concatenate(transform)
            
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.invertParameters.width, height: image.invertParameters.height))
            
            if let newCGImage = context?.makeImage() {
                let ciImage = CIImage(cgImage: newCGImage)
                
                filter.setValue(ciImage, forKey: kCIInputImageKey)
                if let filtered = filter.outputImage {
                    let context = CIContext()
                    if let cgImage = context.createCGImage(filtered, from: filtered.extent) {
                        outputImage = UIImage(cgImage: cgImage)
                    }
                }
            }
            
            DispatchQueue.main.async {
                completion(outputImage)
            }
        }
    }
    
    func mirror(_ image: UIImage, completion: @escaping (UIImage?) -> ()) {
        guard let cgImage = image.cgImage, let colorSpace = cgImage.colorSpace else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delayTime()) {
            var outputImage: UIImage?
            
            let context = CGContext(
                data: nil,
                width: Int(image.size.width),
                height: Int(image.size.height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue).rawValue
            )
            
            let transform = CGAffineTransform.identity
                .translatedBy(x: image.mirrorParameters.translateX, y: image.mirrorParameters.translateY)
                .rotated(by: image.mirrorParameters.rotation)
                .scaledBy(x: image.mirrorParameters.scaleX, y: image.mirrorParameters.scaleY)
            
            context?.concatenate(transform)
            
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.mirrorParameters.width, height: image.mirrorParameters.height))

            if let newCGImage = context?.makeImage() {
                outputImage = UIImage(cgImage: newCGImage)
            }
            
            DispatchQueue.main.async {
                completion(outputImage)
            }
        }
    }
    
    // MARK: - Download
    
    func download(fromURL url: URL) {
        network.download(fromURL: url)
    }
    
    // MARK: - Save to Phto Livrary
    
    func saveToLibrary(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    // MARK: - Database
    
    func getHistory() -> [CFTImage] {
        return (try? database.fetchAll()) ?? []
    }
    
    func saveNew(_ image: CFTImage) {
        try? database.save(image)
    }
    
    func delete(_ image: CFTImage) {
        try? database.delete(image)
    }
    
    func clearHistory() {
        try? database.deleteAll()
    }
}

// MARK: - Network Download Task Observer

extension ImageService: NetworkDownloadObserver {
    func progressUpdated(_ progress: Float) {
        _downloadProgressObserver?.progressUpdated(progress)
    }
    
    func downloadCompleted(_ data: Data) {
        guard let image = UIImage(data: data) else {
            _downloadProgressObserver?.imageLoaded(image: nil, error: CFTError(message: "Unconvertable data"))
            return
        }
        
        saveToLibrary(image)
        _downloadProgressObserver?.imageLoaded(image: image, error: nil)
    }
    
    func errorOccured(_ error: Error?) {
        guard let error = error else {
            return
        }
        _downloadProgressObserver?.imageLoaded(image: nil, error: error)
    }
}
