//
//  NetworkDownloadObserver.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

protocol NetworkDownloadObserver: class {
    func progressUpdated(_ progress: Float)
    func downloadCompleted(_ data: Data)
    func errorOccured(_ error: Error?)
}
