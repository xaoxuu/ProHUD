//
//  ViewExts.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

extension UIView {
    
    static func animateLinear(duration: TimeInterval, delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((_ done: Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: delay, options: [.allowUserInteraction], animations: animations, completion: completion)
    }
    static func animateEaseIn(duration: TimeInterval, delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((_ done: Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: delay, options: [.allowUserInteraction, .curveEaseIn], animations: animations, completion: completion)
    }
    static func animateEaseOut(duration: TimeInterval, animations: @escaping () -> Void, completion: ((_ done: Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [.allowUserInteraction, .curveEaseOut], animations: animations, completion: completion)
    }
    
}
