//
//  ResultCell.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

protocol ResultCellDelegate: class {
    func imageTapped(_ image: CFTImage)
}

class ResultCell: UITableViewCell {
    
    weak var delegate: ResultCellDelegate?
    
    private var data: CFTImage? {
        didSet { setup() }
    }
    
    private var tap: UITapGestureRecognizer!
    
    // MARK: - Outlets
    
    @IBOutlet private weak var resultImageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
    }
    
    override func prepareForReuse() {
        resultImageView.removeGestureRecognizer(tap)
        super.prepareForReuse()
        resultImageView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // MARK: - Private methods
    
    private func setup() {
        if let data = data {
            let image = data.getImage()
            resultImageView.image = image
            if image != nil {
                activityIndicator.isHidden = true
                resultImageView.isHidden = false
                resultImageView.addGestureRecognizer(tap)
            } else {
                activityIndicator.startAnimating()
                activityIndicator.isHidden = false
                resultImageView.isHidden = true
                resultImageView.removeGestureRecognizer(tap)
            }
        } else {
            resultImageView.image = nil
            resultImageView.removeGestureRecognizer(tap)
        }
    }
    
    @objc private func imageTap() {
        if let data = data {
            delegate?.imageTapped(data)
        }
    }
    
    // MARK: - Public methods
    
    func setData(_ data: CFTImage) {
        self.data = data
    }
}
