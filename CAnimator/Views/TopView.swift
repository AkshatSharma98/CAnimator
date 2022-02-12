//
//  TopView.swift
//  CAnimator
//
//  Created by Akshat Sharma on 22/01/22.
//

import Foundation
import UIKit

final class TopView: UIView {
    
    //MARK: Private vars
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    //MARK: UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.alpha = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateConstraint(bottom: CGFloat, text: String?) {
        self.bottomLayoutConstraint?.constant = -bottom
        label.text = text
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: [.curveEaseIn],
                       animations:  { [weak self] in
            self?.label.alpha = 1
            self?.layoutIfNeeded()
        }, completion: nil)
    }
}

private extension TopView {
    
    func addViews() {
        addSubview(containerView)
        containerView.addSubview(label)
    }
    
    func createViews() {
        NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 24).isActive = true
        
        NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant:-24).isActive = true
        
        bottomLayoutConstraint =  NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        
        bottomLayoutConstraint?.isActive = true
    }
}
