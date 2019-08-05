//
//  HUDView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD {
    
    class StackContainer: UIStackView {
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            spacing = cfg.alert.margin
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
            
            if #available(iOS 13.0, *) {
                super.init(effect: UIBlurEffect(style: .systemMaterial))
            } else {
                super.init(effect: UIBlurEffect(style: .extraLight))
            }
            
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
    
    class func animateForGuard(animations: @escaping () -> Void) {
        animateForGuard(animations: animations, completion: nil)
    }
    
    class func animateForGuard(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 0.6, delay: 0, animations: animations, completion: completion)
    }
}
