//
//  DataBaseManagerType.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

protocol DataBaseManagerType: class {
    func save(_ images: [CFTImage]) throws
    func save(_ image: CFTImage) throws
    func fetchAll() throws -> [CFTImage]?
    func deleteAll() throws
    func delete(_ image: CFTImage) throws
}
