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
var isPortrait: Bool {
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

var isPhonePortrait: Bool {
    UIDevice.current.userInterfaceIdiom == .phone && (AppContext.windowScene?.interfaceOrientation.isPortrait == true)
}


// 层级： Capsule(top) -> Toast -> 原生Alert -> Alert -> Capsule(middle) -> Sheet -> Capsule(bottom)
extension UIWindow.Level {

    public static let phCapsuleTop: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue + 1005)
    
    public static let phToast: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue + 1000)
    
    public static let phAlert: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue - 10)
    
    public static let phCapsuleMiddle: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue - 15)

    public static let phSheet: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue - 20)
    
    public static let phCapsuleBottom: UIWindow.Level = .init(rawValue: UIWindow.Level.alert.rawValue - 25)
    
}
