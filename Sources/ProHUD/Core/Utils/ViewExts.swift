//
//  ViewExts.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

extension UIView {
    
    static func animateEaseOut(duration: TimeInterval, animations: @escaping () -> Void, completion: ((_ done: Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseOut], animations: animations, completion: completion)
    }
    
}
