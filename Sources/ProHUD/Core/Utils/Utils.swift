//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

extension UIImage {
    public convenience init?(inProHUD named: String) {
        self.init(named: named, in: .module, with: .none)
    }
}


/// 是否是竖屏(紧凑布局)模式
internal var isPortrait: Bool {
    if AppContext.appBounds.width < 450 {
        return true
    }
    if UIDevice.current.userInterfaceIdiom == .phone {
        if AppContext.windowScene?.interfaceOrientation.isPortrait == true {
            return true
        }
    }
    return false
}
