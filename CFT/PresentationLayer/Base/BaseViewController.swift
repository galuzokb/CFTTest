//
//  BaseViewController.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let attributedTitle = NSAttributedString(string: title, attributes: [.font: Constants.Font.system(ofSize: 20.0)])
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        
        let attributedMessage = NSAttributedString(string: message, attributes: [.font: Constants.Font.system(ofSize: 13.0)])
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        alert.view.tintColor = Constants.Color.main
        
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - View Input

extension BaseViewController: ViewInput {
    func showMessage(_ message: String) {
        showAlert(withTitle: "Message", andMessage: message)
    }
    
    func showError(_ errorMessage: String) {
        showAlert(withTitle: "Error", andMessage: errorMessage)
    }
}

// MARK: - UITextFieldDelegate

extension BaseViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
}
