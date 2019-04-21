//
//  MainViewController.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit
import Photos

class MainViewController: BaseViewController {
    
    var output: MainViewOutput!
    var displayManager: MainDisplayManager!
    
    private var downloadTextField: UITextField?
    private var currentImageViewTap: UITapGestureRecognizer!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var currentImageView: PlaceholderImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var rotateButton: UIButton!
    @IBOutlet private weak var invertButton: UIButton!
    @IBOutlet private weak var mirrorButton: UIButton!
    @IBOutlet private weak var downloadActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var downloadProgressLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let presenter = MainPresenter()
        presenter.view = self
        output = presenter
    }
    
    // MARK: - Actions
    
    @IBAction private func rotateTap(_ sender: UIButton) {
        output.filterButtonTapped(.rotate, forImage: currentImageView.nonPlaceholderImage)
    }
    
    @IBAction private func invertColorTap(_ sender: UIButton) {
        output.filterButtonTapped(.invert, forImage: currentImageView.nonPlaceholderImage)
    }
    
    @IBAction private func mirrorImageTap(_ sender: UIButton) {
        output.filterButtonTapped(.mirror, forImage: currentImageView.nonPlaceholderImage)
    }
    
    // MARK: - Private methods
    
    private func pickImage(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.view.tintColor = Constants.Color.main
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func currentImageViewTapState(_ active: Bool) {
        if active {
            currentImageView.addGestureRecognizer(currentImageViewTap)
        } else {
            currentImageView.removeGestureRecognizer(currentImageViewTap)
        }
    }
    
    @objc func currentImageTap() {
        output.currentImageTapped()
    }
}

// MARK: - View Input

extension MainViewController: MainViewInput {
    func setupInitialState() {
        displayManager = MainDisplayManager(tableView: tableView)
        displayManager.delegate = self
        
        currentImageViewTap = UITapGestureRecognizer(target: self, action: #selector(currentImageTap))
        currentImageViewTapState(true)
    }
    
    func showImagePickerAction() {
        let imagePickerController = UIAlertController(title: "Choose your image", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.addAction(UIAlertAction(title: "Select from Library", style: .default) { _ in
                self.pickImage(.photoLibrary)
            })
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.addAction(UIAlertAction(title: "Take a photo", style: .default) { _ in
                self.pickImage(.camera)
            })
        }
        
        imagePickerController.addAction(UIAlertAction(title: "Download from...", style: .default, handler: { _ in
            self.showDownloadAction(withURLString: self.downloadTextField?.text)
        }))
        
        guard imagePickerController.actions.count > 0 else {
            showError("Application do not have permissions to pick an image")
            return
        }
        
        imagePickerController.view.tintColor = Constants.Color.main
        
        imagePickerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setTableViewState(isHidden: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.tableView.isHidden = isHidden
            }
        } else {
            self.tableView.isHidden = isHidden
        }
    }
    
    func setCurrentImage(_ image: UIImage?) {
        currentImageView.image = image
    }
    
    func setResults(_ images: [CFTImage]) {
        displayManager.setResults(images)
    }
    
    func addResult(_ image: CFTImage) {
        displayManager.addResult(image)
    }
    
    func removeResult(_ image: CFTImage) {
        displayManager.removeResult(image)
    }
    
    func showResultImageAction(forImage image: CFTImage) {
        let resultImageAction = UIAlertController(title: "Select action", message: nil, preferredStyle: .actionSheet)
        
        resultImageAction.addAction(UIAlertAction(title: "Delete from results", style: .destructive, handler: { _ in
            self.output.resultActionTapped(.delete, forImage: image)
        }))
        resultImageAction.addAction(UIAlertAction(title: "Save to Library", style: .default, handler: { _ in
            self.output.resultActionTapped(.save, forImage: image)
        }))
        resultImageAction.addAction(UIAlertAction(title: "Use for further filtering", style: .default, handler: { _ in
            self.output.resultActionTapped(.use, forImage: image)
        }))
        resultImageAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        resultImageAction.view.tintColor = Constants.Color.main
        
        present(resultImageAction, animated: true, completion: nil)
    }
    
    func showDownloadAction(withURLString urlString: String?) {
        let downloadAlert = UIAlertController(title: "Enter URL", message: nil, preferredStyle: .alert)
        
        downloadAlert.addTextField { textFiled in
            textFiled.text = urlString
            textFiled.placeholder = "https://example.com"
            textFiled.textColor = Constants.Color.main
            self.downloadTextField = textFiled
        }
        
        downloadAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.downloadTextField = nil
        }))
        
        downloadAlert.addAction(UIAlertAction(title: "Example", style: .default, handler: { _ in
            self.output.downloadExampleTap()
        }))
        
        downloadAlert.addAction(UIAlertAction(title: "Download", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.output.downloadTap(withURLString: self.downloadTextField?.text)
            }
        }))
        
        downloadAlert.view.tintColor = Constants.Color.main
        
        present(downloadAlert, animated: true, completion: nil)
    }
    
    func startDownloadIndicator() {
        downloadActivityIndicator.isHidden = false
        downloadActivityIndicator.startAnimating()
        currentImageViewTapState(false)
        progressBar.isHidden = false
        downloadTextField = nil
        downloadProgressLabel.isHidden = false
    }
    
    func stopDownloadIndicator() {
        downloadActivityIndicator.stopAnimating()
        downloadActivityIndicator.isHidden = true
        currentImageViewTapState(true)
        progressBar.isHidden = true
        progressBar.progress = 0.0
        downloadProgressLabel.text = nil
        downloadProgressLabel.isHidden = true
    }
    
    func updateProgress(_ progress: Float, percent: String) {
        progressBar.progress = progress
        downloadProgressLabel.text = percent
    }
}

// MARK: - Main Display Manager Delegate

extension MainViewController: MainDisplayManagerDelegate {
    func imageTapped(_ image: CFTImage) {
        output.onResultImageTap(image)
    }
}

// MARK: - Image Picker Delegate

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.output.pickedImage(image)
        }
    }
}

