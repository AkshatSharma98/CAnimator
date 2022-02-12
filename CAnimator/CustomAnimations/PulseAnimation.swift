//
//  PulseAnimation.swift
//  CAnimator
//
//  Created by Akshat Sharma on 22/01/22.
//

import Foundation
import UIKit

final class PulseAnimation: CALayer {

    //MARK: Private vars
    private var animationGroup = CAAnimationGroup()
    private var radius: CGFloat = 200
    private var numberOfPulse: Float = Float.infinity
    
    var animationDuration: TimeInterval = 1.5
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(numberOfPulse: Float = Float.infinity, radius: CGFloat, postion: CGPoint){
        super.init()
        backgroundColor = UIColor.black.cgColor
        contentsScale = UIScreen.main.scale
        opacity = 0
        self.radius = radius
        self.numberOfPulse = numberOfPulse
        self.position = postion
        
        bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            self?.setupAnimationGroup()
            DispatchQueue.main.async { [weak self] in
                guard let unwrappedAnimationGroup = self?.animationGroup else {
                    return
                }
                self?.add(unwrappedAnimationGroup, forKey: "pulse")
           }
        }
    }
}

private extension PulseAnimation {
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimaton = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimaton.fromValue = NSNumber(value: 0)
        scaleAnimaton.toValue = NSNumber(value: 1)
        scaleAnimaton.duration = animationDuration
        return scaleAnimaton
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4,0.8,0]
        opacityAnimation.keyTimes = [0,0.3,1]
        return opacityAnimation
    }
    
    func setupAnimationGroup() {
        self.animationGroup.duration = animationDuration
        self.animationGroup.repeatCount = numberOfPulse
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        self.animationGroup.animations = [scaleAnimation(), createOpacityAnimation()]
    }
}
