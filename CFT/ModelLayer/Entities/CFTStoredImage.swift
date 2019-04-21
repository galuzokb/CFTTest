//
//  CFTStoredImage.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import CoreData

// MARK: - Init with MerchantItem

extension CFTStoredImage {
    @available (iOS 10.0, *)
    convenience init(_ cftImage: CFTImage, withContext context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = cftImage.id
        self.modificationDate = cftImage.modificationDate
        self.imageData = cftImage.getImageData() ?? Data()
    }
    
    convenience init(_ cftImage: CFTImage, withContext context: NSManagedObjectContext, entity: NSEntityDescription) {
        self.init(entity: entity, insertInto: context)
        self.id = cftImage.id
        self.modificationDate = cftImage.modificationDate
        self.imageData = cftImage.getImageData() ?? Data()
    }
}
