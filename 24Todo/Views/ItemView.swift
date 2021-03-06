//
//  ItemView.swift
//  24Todo
//
//  Created by Prudhvi Gadiraju on 3/29/19.
//  Copyright © 2019 Prudhvi Gadiraju. All rights reserved.
//

import UIKit
import Lottie

class ItemView: UIView {
    
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    var dotAnimationView: LOTAnimationView!
    let bgView = UIView()
    
    var draggableView = UIView()
    var originalBGView: CGRect!
    var panGesture: UIPanGestureRecognizer?
    var tapGesture: UITapGestureRecognizer?
    
    weak var delegate: MainViewController?
    
    var item: Item! {
        didSet {
            setupView()
        }
    }
    
    fileprivate func setTitleLabel() {
        titleLabel.text = item.title
        titleLabel.font = Theme.theme.itemListFont
        titleLabel.textColor = Theme.theme.itemTextColor
        
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: dotAnimationView.trailingAnchor, constant: -11).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
    }
    
    fileprivate func setDotAnimationView() {
        dotAnimationView = LOTAnimationView(name: "ItemCompletionAnimation_\(item.color)")
        dotAnimationView.frame = CGRect(x: 0, y: 0, width: 52, height: 52)
        dotAnimationView.contentMode = .scaleAspectFill

        dotAnimationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleItemCompletionTapped)))
        
        if item.isDone {
            dotAnimationView.animationProgress = 1
            //print(item.isDone)
        } else {
            dotAnimationView.animationProgress = 0
        }
        
        addSubview(dotAnimationView)
        //print("adding dot animationView for \(item.title)")
        
        dotAnimationView.translatesAutoresizingMaskIntoConstraints = false
        dotAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        dotAnimationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -3).isActive = true
        dotAnimationView.widthAnchor.constraint(equalToConstant: 52).isActive = true
        dotAnimationView.heightAnchor.constraint(equalToConstant: 52).isActive = true
    }
    
    func setupDraggableView() {
        draggableView = UIView(frame: CGRect(x: bgView.frame.minX, y: bgView.frame.maxY-10, width: frame.width, height: CGFloat(10)))
        draggableView.backgroundColor = Theme.theme.colorMap[item.color]
        
        panGesture = (UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        bgView.addGestureRecognizer(panGesture!)
        bgView.addGestureRecognizer(tapGesture!)

        
        addSubview(draggableView)
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        draggableView.isHidden = true
        bgView.removeGestureRecognizer(panGesture!)
        bgView.removeGestureRecognizer(tapGesture!)
        delegate?.handleDrop(withNewLength: 60)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            handlePanBegan(gesture)
        case .changed:
            handlePanChanged(gesture)
        case .ended:
            handlePanEnded(gesture)
        default:
            break
        }
    }
    
    fileprivate func handlePanBegan(_ gesture: UIPanGestureRecognizer) {
        //print("Began")
        originalBGView = bgView.frame
    }
    
    fileprivate func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        var updatedHeight = originalBGView.height + translation.y
        
        if updatedHeight < 30 {
            updatedHeight = 30
        }
        
        bgView.frame = CGRect(x: 0, y: 0, width: bgView.frame.width, height: updatedHeight)
        draggableView.frame = CGRect(x: 0, y: bgView.frame.maxY, width: draggableView.frame.width, height: draggableView.frame.height)
        
        //print(bgView.frame)
    }
    
    fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        draggableView.isHidden = true
        bgView.removeGestureRecognizer(panGesture!)
        delegate?.handleDrop(withNewLength: Int(bgView.frame.maxY))
    }
    
    fileprivate func setupView() {
        setDotAnimationView()
        setTitleLabel()
    }
    
    func convertView() {
        bgView.backgroundColor = Theme.theme.colorMap[item.color]
        bgView.alpha = 0.6
        
        addSubview(bgView)
        sendSubviewToBack(bgView)
        
        bgView.fillSuperview()
        
        dotAnimationView.isHidden = true
    }
    
    @objc fileprivate func handleItemCompletionTapped() {
        item.isDone = !item.isDone
        
        if item.isDone {
            dotAnimationView.play()
        } else {
            dotAnimationView.animationProgress = 0
        }
    }
}
