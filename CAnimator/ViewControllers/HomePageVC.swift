//
//  HomePageVC.swift
//  CAnimator
//
//  Created by Akshat Sharma on 23/01/22.
//

import Foundation
import UIKit

final class HomePageVC: UIViewController {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let button1: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("See Success Case", for: .normal)
        return button
    }()
    
    private let button2: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("See Failure Case", for: .normal)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        button1.addTarget(self, action: #selector(button1Target), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Target), for: .touchUpInside)
    }
}

private extension HomePageVC {
    
    @objc func button1Target() {
        let vc = CVC(modelCase: .success)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func button2Target() {
        let vc = CVC(modelCase: .failure)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        
        NSLayoutConstraint(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
