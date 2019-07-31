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
            spacing = hud.config.alert.margin
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
    
    class func animateFastEaseOut(delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 0.5, delay: delay, animations: animations, completion: completion)
    }
    
    class func animateSlowEaseOut(delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 2, delay: delay, animations: animations, completion: completion)
    }
    
}
