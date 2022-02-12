//
//  ViewController.swift
//  CAnimator
//
//  Created by Akshat Sharma on 21/01/22.
//

import Foundation
import UIKit

final class CVC: CBaseViewController {
    
    //MARK: Private vars
    private var initialCenter: CGPoint?
    private var isDragged: Bool = false
    private var pulse: PulseAnimation?
    private var vm: CVMProtocol?
    private let modelCase: ModelCase
    private var initialYTranslation: CGFloat = 0
    private let yDisplacement: CGFloat = 6
    private let defaultAnimationDuration: Double = 0.5
    private let specialAnimationDuration: Double = 0.34
    
    //MARK: UI
    private let draggableView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.backgroundColor = .blue
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "epl")
        view.backgroundColor = .black
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let targetView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 50
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 4
        return view
    }()
    
    private let topView: TopView = {
        let view = TopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let blinkView1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "chevron.right")
        view.transform = CGAffineTransform(rotationAngle: .pi/2)
        view.tintColor = .gray
        view.alpha = 1
        return view
    }()
    
    private let blinkView2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "chevron.right")
        view.transform = CGAffineTransform(rotationAngle: .pi/2)
        view.tintColor = .green
        view.alpha = 0
        return view
    }()
    
    init(modelCase: ModelCase) {
        self.modelCase = modelCase
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Commons.getColorFromHex(hex: "#171717")
        addViews()
        createViews()
        createDraggableViewBounceAnimation()
        addPanG()
        createBlinkAnimation()
        vm = CommonInjector.getCVM(modelCase: modelCase,
                                      delegate: self,
                                      api: APIManagerRepo())
    }
}
                       
extension CVC: CVMDelegate {
    
    func didFetchData(_ forClass: CVMProtocol, response: Response?) {
        response?.success == true ? handleSuccess() : handleFailure()
    }
    
    func didFailToFetchData(_ forClass: CVMProtocol) {
        handleFailure()
    }
}

private extension CVC {
    
    func addPanG() {
        let panG = UIPanGestureRecognizer(target: self, action: #selector(handlePanG))
        draggableView.addGestureRecognizer(panG)
    }
    
    @objc func handlePanG(gesture: UIPanGestureRecognizer) {
        guard let target = gesture.view, isDragged != true else {
            return
        }
        
        switch gesture.state {
        case .began:
            target.layer.removeAllAnimations()
            if initialCenter == nil {
                initialCenter = target.center
            }
            target.center.y += yDisplacement
            
        case .ended:
            checkIfDragged(target: target)
            
        case .changed:
            let translation = gesture.translation(in: view)
            
            guard let unwrappedInitialCenter = initialCenter else {
                return
            }
            
            let displacementY = max(unwrappedInitialCenter.y,
                                    min(unwrappedInitialCenter.y + translation.y + yDisplacement, targetView.center.y))
            
            target.center = CGPoint(x: unwrappedInitialCenter.x, y: displacementY)

        default: break
        }
    }
    
    func checkIfDragged(target: UIView) {
        if target.center.y - targetView.center.y == 0 {
            target.center.y = targetView.center.y
            target.isUserInteractionEnabled = false
            isDragged = true
            handleDrop()
        } else {
            handleDragFailure()
        }
    }
}

extension CVC {
    
    func createBlinkAnimation() {
        UIView.animate(withDuration: defaultAnimationDuration,
                       delay:0.0,
                       options:[.curveEaseInOut, .autoreverse, .repeat, .beginFromCurrentState],
                       animations: { [weak self] in
            self?.blinkView1.alpha = 0
            self?.blinkView2.alpha = 1
        },
                       completion: nil)
    }
    
    func createDraggableViewBounceAnimation() {
        UIView.animate(withDuration: defaultAnimationDuration,
                       delay: 0,
                       options: [ .repeat,
                                  .autoreverse,
                                  .allowUserInteraction]) { [weak self] in
            self?.draggableView.transform = CGAffineTransform(translationX: 0, y: self?.yDisplacement ?? 0)
        } completion: { [weak self] _ in
            self?.draggableView.transform = .identity
        }
    }
    
    func createPulsatingLayer() {
        pulse = PulseAnimation(numberOfPulse: Float.infinity,
                               radius: 150,
                               postion: targetView.center)
        pulse?.animationDuration = 1.0
        pulse?.backgroundColor = UIColor.gray.withAlphaComponent(1).cgColor
        guard let unwrappedPulse = pulse else {
            return
        }
        view.layer.insertSublayer(unwrappedPulse, below: view.layer)
    }
    
    func removePulsatingLayer() {
        pulse?.removeFromSuperlayer()
    }
    
    func handleDrop() {
        UIView.animate(withDuration: specialAnimationDuration,
                       delay: 0,
                       options: [],
                       animations: { [weak self] in
            self?.draggableView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
            completion: nil)
        createPulsatingLayer()
        vm?.getData()
    }
    
    func handleDragFailure() {
        isDragged = false
        draggableView.isUserInteractionEnabled = false
        UIView.animate(withDuration: defaultAnimationDuration, delay: 0, options: []) { [weak self] in
            guard let unwrappedInitialCenter = self?.initialCenter else {
                return
            }
            self?.draggableView.center = unwrappedInitialCenter
            self?.draggableView.transform = .identity
        } completion: { [weak self] _ in
            self?.draggableView.isUserInteractionEnabled = true
            self?.createDraggableViewBounceAnimation()
        }
    }
    
    func showAlert() {
        showToast(message: "failed", controller: self)
    }
    
    func handleSuccess() {
        self.draggableView.isHidden = true
        self.removePulsatingLayer()
        UIView.animate(withDuration: defaultAnimationDuration,
                       delay: 0,
                       options: [.curveEaseIn]) { [weak self] in
            self?.targetView.transform = CGAffineTransform(translationX: 0, y: 500)
            self?.topView.transform = CGAffineTransform(translationX: 0,
                                                        y: -38)
            self?.draggableView.alpha = 0
            self?.topView.updateConstraint(bottom: 50, text: "Success")
        } completion: { [weak self] _ in
            self?.blinkView2.isHidden = true
            self?.blinkView1.isHidden = true
        }
    }
    
    func handleFailure() {
        isDragged = false
        UIView.animate(withDuration: 0.5, delay: specialAnimationDuration, options: []) { [weak self] in
            guard let unwrappedInitialCenter = self?.initialCenter else {
                return
            }
            self?.draggableView.center = unwrappedInitialCenter
            self?.draggableView.transform = .identity
        } completion: { [weak self] _ in
            self?.draggableView.isUserInteractionEnabled = true
            self?.createDraggableViewBounceAnimation()
            self?.pulse?.removeFromSuperlayer()
            self?.showAlert()
        }
    }
}

private extension CVC {
    
    func addViews() {
        view.addSubview(targetView)
        view.addSubview(topView)
        view.addSubview(blinkView1)
        view.addSubview(blinkView2)
        view.addSubview(draggableView)
    }
    
    func createViews() {
        NSLayoutConstraint(item: draggableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: draggableView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: blinkView1, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: blinkView1, attribute: .top, relatedBy: .equal, toItem: draggableView, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        
        NSLayoutConstraint(item: blinkView2, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: blinkView2, attribute: .top, relatedBy: .equal, toItem: draggableView, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        
        draggableView.widthAnchor.constraint(equalToConstant: 100).isActive  = true
        draggableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        blinkView1.widthAnchor.constraint(equalToConstant: 10).isActive  = true
        blinkView1.heightAnchor.constraint(equalToConstant: 20).isActive = true
        blinkView2.widthAnchor.constraint(equalToConstant: 10).isActive  = true
        blinkView2.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        NSLayoutConstraint(item: targetView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: targetView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -(Commons.getNotchHeight() + 20)).isActive = true
        
        targetView.widthAnchor.constraint(equalToConstant: 100).isActive  = true
        targetView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        NSLayoutConstraint(item: topView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 24).isActive = true
        NSLayoutConstraint(item: topView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -24).isActive = true
        
        NSLayoutConstraint(item: topView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: Commons.getTopPaddingForView() + 50).isActive = true
        
        NSLayoutConstraint(item: topView, attribute: .bottom, relatedBy: .equal, toItem: draggableView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
}
