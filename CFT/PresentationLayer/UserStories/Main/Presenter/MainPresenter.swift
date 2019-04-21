//
//  MainPresenter.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

class MainPresenter {
    
    weak var view: MainViewInput?
    
    private var imageService: ImageServiceType
    
    private var filteredImages: [CFTImage] = []
    
    private var processingImages: [CFTImage] = []
    
    init() {
        imageService = ImageService.shared
    }
    
    // MARK: - Events handling
    
    private func handleFilterResult(using cftImage: CFTImage, forFilterType filterType: ImageFilterType, resultImage: UIImage?) {
        guard let resultImage = resultImage else {
            processingImages.removeAll { $0 == cftImage }
            view?.removeResult(cftImage)
            view?.showError("Failed to " + filterType.description + " image")
            return
        }
        var cftImageCopy = cftImage
        processingImages.removeAll { $0 == cftImage }
        cftImageCopy.modificationDate = Date()
        cftImageCopy.setImage(resultImage)
        filteredImages.insert(cftImageCopy, at: 0)
        view?.addResult(cftImageCopy)
        imageService.saveNew(cftImageCopy)
    }
    
    private func handleDeleteAction(forImage image: CFTImage) {
        filteredImages.removeAll { $0 == image }
        view?.removeResult(image)
        imageService.delete(image)
    }
    
    private func handleSaveAction(forImage image: CFTImage) {
        guard let imageToSave = image.getImage() else {
            view?.showError("Failed to save image to Photo Library")
            return
        }
        imageService.saveToLibrary(imageToSave)
    }
    
    private func handleUseAction(forImage image: CFTImage) {
        guard let newImage = image.getImage() else {
            view?.showError("Something when wrong...")
            return
        }
        
        view?.setCurrentImage(newImage)
    }
    
    private func handleDownloadEvent(withURLString urlString: String) {
        guard let url = URL(string: urlString), url.isValid else {
            view?.showError("Enter correct URL!")
            return
        }
        
        view?.startDownloadIndicator()
        imageService.downloadProgressObserver = self
        imageService.download(fromURL: url)
        //        imageService.download(fromURL: url) { [weak self] (image, error) in
        //            self?.view?.stopDownloadIndicator()
        //            if let image = image {
        //                self?.view?.setCurrentImage(image)
        //                self?.view?.stopDownloadIndicator()
        //            } else if let error = error {
        //
        //                self?.view?.showError(error.message())
        //            } else {
        //
        //            }
        //            if let error = error {
        //                self?.view?.showError(error.message())
        //                return
        //            }
        //        }
    }
}

// MARK: - View Output

extension MainPresenter: MainViewOutput {
    func viewIsReady() {
        view?.setupInitialState()
        
        let history = imageService.getHistory()
        view?.setTableViewState(isHidden: history.count == 0, animated: true)
        view?.setResults(history)
    }
    
    func currentImageTapped() {
        view?.showImagePickerAction()
    }
    
    func filterButtonTapped(_ filterType: ImageFilterType, forImage image: UIImage?) {
        guard let image = image else {
            view?.showError("You should select image first!")
            return
        }
        
        if processingImages.isEmpty && filteredImages.isEmpty {
            view?.setTableViewState(isHidden: false, animated: true)
        }
        
        let cftImage = CFTImage()
        processingImages.insert(cftImage, at: 0)
        view?.addResult(cftImage)
        view?.setCurrentImage(nil)
        
        switch filterType {
        case .rotate:
            imageService.rotate(image) { [weak self] image in
                self?.handleFilterResult(using: cftImage, forFilterType: filterType, resultImage: image)
            }
        case .invert:
            imageService.invert(image) { [weak self] image in
                self?.handleFilterResult(using: cftImage, forFilterType: filterType, resultImage: image)
            }
        case .mirror:
            imageService.mirror(image) { [weak self] image in
                self?.handleFilterResult(using: cftImage, forFilterType: filterType, resultImage: image)
            }
        }
    }
    
    func pickedImage(_ image: UIImage) {
        view?.setCurrentImage(image)
    }
    
    func onResultImageTap(_ image: CFTImage) {
        view?.showResultImageAction(forImage: image)
    }
    
    func resultActionTapped(_ action: ResultActionType, forImage image: CFTImage) {
        switch action {
        case .delete:
            handleDeleteAction(forImage: image)
        case .save:
            handleSaveAction(forImage: image)
        case .use:
            handleUseAction(forImage: image)
        }
    }
    
    func downloadTap(withURLString urlString: String?) {
        handleDownloadEvent(withURLString: urlString ?? "")
    }
    
    func downloadExampleTap() {
        handleDownloadEvent(withURLString: Constants.URLs.exampleImage)
    }
}

// MARK: - Download Progress Observer

extension MainPresenter: DownloadProgressObserver {
    func progressUpdated(_ progress: Float) {
        view?.updateProgress(progress, percent: "\(Int(progress * 100))%")
    }
    
    func imageLoaded(image: UIImage?, error: Error?) {
        view?.stopDownloadIndicator()
        if let image = image {
            view?.setCurrentImage(image)
        } else if let error = error {
            view?.showError(error.message())
        } else {
            view?.showError("Download failed")
        }
    }
}
