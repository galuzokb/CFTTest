//
//  NetworkType.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

protocol NetworkType {
    var downloadTaskObserver: NetworkDownloadObserver? { get set }
    func download(fromURL url: URL)
//    func download(fromURL url: URL, withCompletion completion: @escaping (Data?, Error?) -> ())
}
