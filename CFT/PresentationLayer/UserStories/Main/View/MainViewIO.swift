//
//  MainViewIO.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit


protocol MainViewInput: class, ViewInput {
    func setupInitialState()
    
    func showImagePickerAction()
    
    func setTableViewState(isHidden: Bool, animated: Bool)
    
    func setCurrentImage(_ image: UIImage?)
    
    func setResults(_ images: [CFTImage])
    func addResult(_ image: CFTImage)
    func removeResult(_ image: CFTImage)
    
    func showResultImageAction(forImage image: CFTImage)
    
    func showDownloadAction(withURLString urlString: String?)
    
    func startDownloadIndicator()
    func stopDownloadIndicator()
    func updateProgress(_ progress: Float, percent: String)
}

protocol MainViewOutput {
    func viewIsReady()
    
    func currentImageTapped()
    
    func filterButtonTapped(_ filterType: ImageFilterType, forImage image: UIImage?)
    
    func pickedImage(_ image: UIImage)
    
    func onResultImageTap(_ image: CFTImage)
    
    func resultActionTapped(_ action: ResultActionType, forImage image: CFTImage)
    
    func downloadTap(withURLString urlString: String?)
    
    func downloadExampleTap()
}
