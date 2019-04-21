//
//  Network.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/21/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import Foundation

class Network: NSObject {
    static let shared = Network()
    
    private var urlSession: URLSession!
    
    private weak var _downloadTaskObserver: NetworkDownloadObserver?
    
    private var downloadData: Data?
    
    override init() {
        super.init()
        // Just to reduce wait time if download url is wrong
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20.0
        configuration.timeoutIntervalForResource = 30.0
        self.urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
    }
}

extension Network: NetworkType {
    var downloadTaskObserver: NetworkDownloadObserver? {
        get {
            return _downloadTaskObserver
        }
        set {
            _downloadTaskObserver = newValue
        }
    }
    
    func download(fromURL url: URL) {
        downloadData = Data()
        urlSession.dataTask(with: url).resume()
    }
    
//    func download(fromURL url: URL, withCompletion completion: @escaping (Data?, Error?) -> ()) {
//        urlSession.dataTask(with: url) { (data, response, error) in
//            DispatchQueue.main.async {
//                completion(data, error)
//            }
//        }.resume()
//    }
}

// MARK: - URL Session Delegate,  URL Session Download Delegate

extension Network: URLSessionDataDelegate, URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else {
            return
        }
        _downloadTaskObserver?.errorOccured(error)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error  = error else {
            return
        }
        _downloadTaskObserver?.errorOccured(error)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        downloadData?.append(data)
        let progress = Float(dataTask.countOfBytesReceived) / Float(dataTask.countOfBytesExpectedToReceive)
        if progress != 1 {
            _downloadTaskObserver?.progressUpdated(progress)
        } else if let downloaded = downloadData {
            _downloadTaskObserver?.downloadCompleted(downloaded)
        } else {
            _downloadTaskObserver?.errorOccured(CFTError(message: "Download failed"))
        }
    }
}
