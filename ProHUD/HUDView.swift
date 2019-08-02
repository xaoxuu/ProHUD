//
//  HUDView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD {
    
    class ToastWindow: UIWindow {
        
        var deviceOrientationDidChangeCallback: (() -> Void)?
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        @objc func deviceOrientationDidChange(_ notification: Notification){
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.deviceOrientationDidChangeCallback?()
            }
        }
        
    }
    
    class StackContainer: UIStackView {
        
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            spacing = alertConfig.margin
            distribution = .fill
            alignment = .center
            axis = .vertical
            
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    class BlurView: UIVisualEffectView {
        
        
        init() {
            super.init(effect: UIBlurEffect(style: .light))
            backgroundColor = UIColor.init(white: 1, alpha: 0.66)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
}

internal extension UIView {
    
    class func animateEaseOut(duration: TimeInterval = 1, delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseOut], animations: animations, completion: completion)
    }
    
    class func animateForAlertBuildIn(animations: @escaping () -> Void) {
        animateEaseOut(duration: 0.8, delay: 0, animations: animations, completion: nil)
    }
    class func animateForAlertBuildOut(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 0.38, delay: 0, animations: animations, completion: completion)
    }
    class func animateForAlert(animations: @escaping () -> Void) {
        animateEaseOut(duration: 1, delay: 0, animations: animations, completion: nil)
    }
    
    class func animateForAlert(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 1, delay: 0, animations: animations, completion: completion)
    }
    
    class func animateForToast(animations: @escaping () -> Void) {
        animateEaseOut(duration: 1, delay: 0, animations: animations, completion: nil)
    }
    
    class func animateForToast(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 1, delay: 0, animations: animations, completion: completion)
    }
    
}
