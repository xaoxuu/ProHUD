//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit
import Inspire

var screenSafeAreaInsets: UIEdgeInsets {
    Inspire.shared.screen.safeAreaInsets
}

extension UIImage {
    public convenience init?(inProHUD named: String) {
        if #available(iOS 13.0, *) {
            self.init(named: named, in: .module, with: .none)
        } else {
            self.init(named: named)
        }
    }
}


/// 是否是手机竖屏模式
internal var isPortrait: Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            return true
        }
    }
    return false
}
