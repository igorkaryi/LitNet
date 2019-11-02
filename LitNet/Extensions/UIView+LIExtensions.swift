//
//  UIView+LIExtensions.swift
//  LitNet
//
//  Created by Igor Karyi on 30.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import UIKit

// MARK: - Animation logic
extension UIView {
    
    @inline(__always)
    static func defaultAnimate(duration: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        self.performAnimation(duration: duration, block: animations, completion: completion)
    }
    
    @inline(__always)
    static func defaultAnimate(duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        self.performAnimation(duration: duration, delay: delay, block: animations, completion: completion)
    }
    
    @inline(__always)
    static func defaultAnimate(animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        self.defaultAnimate(
            duration: CATransaction.animationDuration(),
            animations: animations,
            completion: completion
        )
    }
    
    @inline(__always)
    static func perfromAnimationIfNeeded(animated: Bool, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.defaultAnimate(animations: animations, completion: completion)
        } else {
            animations()
            completion?(true)
        }
    }
    
    @inline(__always)
    static func performAnimation(duration: TimeInterval, block: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        self.performAnimation(duration: duration, delay: 0, block: block, completion: completion)
    }
    
    static func performAnimation(duration: TimeInterval, delay: TimeInterval, block: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            let anim = UIViewPropertyAnimator(
                duration: duration,
                curve: .easeInOut,
                animations: block
            )
            
            anim.addCompletion { pos in
                if pos == .end {
                    completion?(true)
                }
            }
            
            anim.startAnimation()
        } else {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.beginFromCurrentState, .curveEaseInOut],
                animations: block,
                completion: completion
            )
        }
    }
    
    func addAnimationIfNeeded(_ animated: Bool) {
        if animated {
            let transition = CATransition()
            transition.duration = CATransaction.animationDuration()
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = CATransitionType.fade
            transition.isRemovedOnCompletion = true
            self.layer.add(transition, forKey: nil)
        }
    }
    
}

extension UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    class func viewWithDefaultNib() -> Self {
        return self.viewWithType()
    }
    
    class func defaultNib() -> UINib {
        return UINib(nibName: stringFromClass(self), bundle: nil)
    }
    
    func calculateSize() -> CGSize {
        return self.calculateSize(forWidth: UIView.layoutFittingCompressedSize.width)
    }
    
    func calculateSize(forWidth width: CGFloat) -> CGSize {
        let maxSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        
        let size = self.systemLayoutSizeFitting(
            maxSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    
    func setIsExclusiveTouch(_ value: Bool, recursive: Bool) {
        self.isExclusiveTouch = value
        
        if recursive {
            for subview in self.subviews {
                subview.setIsExclusiveTouch(value, recursive: recursive)
            }
        }
    }
    
}

// MARK: - Private Methods

private extension UIView {
    
    class func viewWithType<T>() -> T {
        let nib = UINib(nibName: stringFromClass(self), bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil).first as! T
    }
    
}

func stringFromClass(_ anyClass: AnyClass) -> String {
    return NSStringFromClass(anyClass).components(separatedBy: ".").last!
}

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

