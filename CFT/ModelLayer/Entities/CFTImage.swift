//
//  CFTImage.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

struct CFTImage {
    let id: String
    var modificationDate: Date
    private var imageData: Data?
    private var image: UIImage?
    
    init() {
        self.id = UUID().uuidString
        self.modificationDate = Date()
    }
    
    init(id: String, modificationDate: Date = Date(), imageData: Data) {
        self.id = id
        self.modificationDate = modificationDate
        self.imageData = imageData
        self.image = UIImage(data: imageData)
    }
    
    init(id: String, modificationDate: Date = Date(), image: UIImage) {
        self.id = id
        self.modificationDate = modificationDate
        self.image = image
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    
    func getImage() -> UIImage? {
        if image != nil {
            return image
        } else if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    mutating func setImage(_ image: UIImage?) {
        if let image = image {
            self.image = image
            self.imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            self.image = nil
            self.imageData = nil
        }
    }
    
    func getImageData() -> Data? {
        if imageData != nil {
            return imageData
        } else if let image = image {
            return image.jpegData(compressionQuality: 1.0)
        }
        return nil
    }
    
    mutating func setImageData(_ data: Data?) {
        if let data = data {
            self.image = UIImage(data: data)
            self.imageData = data
        } else {
            self.image = nil
            self.imageData = nil
        }
    }
}

extension CFTImage: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: CFTImage, rhs: CFTImage) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Init with CFTStoreImage

extension CFTImage {
    init(_ stored: CFTStoredImage) {
        self.id = stored.id ?? UUID().uuidString
        self.modificationDate = stored.modificationDate ?? Date()
        self.setImageData(stored.imageData)
    }
}
