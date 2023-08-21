//
//  CapsuleWindow.swift
//
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

class CapsuleWindow: Window {
    
    var capsule: CapsuleTarget
    
    init(capsule: CapsuleTarget) {
        self.capsule = capsule
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        windowScene = AppContext.windowScene
        switch capsule.vm?.position {
        case .top, .none:
            // 略高于toast
            windowLevel = .phCapsuleTop
        case .middle:
            // 略低于alert
            windowLevel = .phCapsuleMiddle
        case .bottom:
            // 略高于sheet
            windowLevel = .phCapsuleBottom
        }
        frame = .init(x: 0, y: 0, width: 128, height: 48)
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CapsuleTarget {
    var attachedWindow: CapsuleWindow? {
        view.window as? CapsuleWindow
    }
}
