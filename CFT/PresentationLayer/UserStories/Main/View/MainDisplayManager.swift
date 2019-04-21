//
//  MainDisplayManager.swift
//  CFT
//
//  Created by Kirill Galuzo on 4/20/19.
//  Copyright © 2019 galuzokb@gmail.com. All rights reserved.
//

import UIKit

protocol MainDisplayManagerDelegate: class {
    func imageTapped(_ image: CFTImage)
}

class MainDisplayManager: NSObject {
    
    weak var delegate: MainDisplayManagerDelegate?
    
    private let tableView: UITableView
    private var images: [CFTImage] = []
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        super.init()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    func setResults(_ images: [CFTImage]) {
        self.images = images
        tableView.reloadData()
    }
    
    func addResult(_ image: CFTImage) {
        if images.isEmpty {
            setResults([image])
            return
        }
        
        tableView.beginUpdates()
        var indexPath: IndexPath
        
        if let index = images.firstIndex(of: image) {
            images[index] = image
            indexPath = IndexPath(row: index, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            images.insert(image, at: 0)
            indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        tableView.endUpdates()
    }
    
    func removeResult(_ image: CFTImage) {
        if images.count == 1 {
            setResults([])
            return
        }
        
        tableView.beginUpdates()
        if let index = images.firstIndex(of: image) {
            images.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        tableView.endUpdates()
    }
}

// MARK: - Table View Data Source

extension MainDisplayManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return images.count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as? ResultCell else {
            fatalError("Can't dequeue reusable cell with id \"resultCell\"")
        }
        cell.setData(images[indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: - Table View Delegate

extension MainDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return images[indexPath.row].getImage() != nil ? 220.0 : 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard images.count > 0 else {
            return nil
        }
        
        let view = UITableViewHeaderFooterView()
        view.backgroundView?.backgroundColor = Constants.Color.main
        view.textLabel?.text = "Results"
        view.textLabel?.textColor = UIColor.white
        return view
    }
}

// MARK: - Result Cell Delegate

extension MainDisplayManager: ResultCellDelegate {
    func imageTapped(_ image: CFTImage) {
        delegate?.imageTapped(image)
    }
}
