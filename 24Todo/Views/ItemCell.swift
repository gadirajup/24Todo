//
//  ItemCell.swift
//  24Todo
//
//  Created by Prudhvi Gadiraju on 3/29/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    let titleLabel = UILabel()
    let dateLabel = UILabel()
    
    var item: Item! {
        didSet {
            setupView()
            setupGestureRecognizers()
        }
    }
    
    fileprivate func setupView() {
        
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        
    
        if let startTime = item.startTime, let length = item.length {
            dateLabel.text = "\(startTime) - \(length)"
            dateLabel.font = UIFont.systemFont(ofSize: 8, weight: .light)
            
            addSubview(dateLabel)
            
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 3).isActive = true
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16).isActive = true
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        }

    }
    
    fileprivate func setupGestureRecognizers() {
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    fileprivate func handleLongPressBegan() {
        NotificationCenter.default.post(name: NSNotification.Name.didLongPressOnCell, object: nil, userInfo: ["item": item!, "frame": frame])
    }
    
    @objc fileprivate func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            handleLongPressBegan()
            break
        default:
            break
        }
    }
}