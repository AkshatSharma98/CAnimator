//
//  CBaseViewController.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation
import UIKit

class CBaseViewController: UIViewController {
    
    private let toastContainer: UIView  = {
        let toastContainer = UIView()
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.isUserInteractionEnabled = false
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds = true
        return toastContainer
    }()
    
    private let toastLabel: UILabel = {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.isUserInteractionEnabled = false
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.clipsToBounds  = true
        toastLabel.numberOfLines = 0
        return toastLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToastContainer()
    }
    
    private func setupToastContainer() {
        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        
        NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15).isActive = true


        NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 65).isActive = true
        
        NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -65).isActive = true
        
        NSLayoutConstraint(item: toastContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 75).isActive = true
    }
    
    func showToast(message: String, controller: UIViewController) {
        toastLabel.text = message
        view.bringSubviewToFront(toastContainer)

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
            self?.toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: { [weak self] in
                self?.toastContainer.alpha = 0.0
            }, completion: nil)
        })
    }
}
