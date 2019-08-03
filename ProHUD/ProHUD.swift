//
//  ProHUD.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/23.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

internal let hud = ProHUD.shared

public class ProHUD {
    
    public static let shared = ProHUD()
    
    internal var toasts = [Toast]()
    internal var alerts = [Alert]()
    
    internal var alertWindow: UIWindow?
    
    
}


internal extension ProHUD {
    
    static var bundle: Bundle {
        var b = Bundle.init(for: ProHUD.Alert.self)
        let p = b.path(forResource: "ProHUD", ofType: "bundle")
        if let bb = Bundle.init(path: p ?? "") {
            b = bb
        }
        return b
    }
    
    static func image(named: String) -> UIImage? {
        return UIImage.init(named: named, in: bundle, compatibleWith: nil)
    }
    
    
}

internal var isPortrait: Bool {
    if UIScreen.main.bounds.width < 500 {
        return true
    } else {
        return false
    }
}


internal var dynamicColor: UIColor {
    if #available(iOS 13.0, *) {
        let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
        return color
    } else {
        // Fallback on earlier versions
    }
    return .init(white: 0.2, alpha: 1)
}



internal var UIColorForPrimaryLabel: UIColor {
    return dynamicColor.withAlphaComponent(0.75)
}
internal var UIColorForSecondaryLabel: UIColor {
    return dynamicColor.withAlphaComponent(0.6)
}

internal extension UIColor {
    
    var dynamicColor: UIColor {
        if #available(iOS 13.0, *) {
            let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
            return color
        } else {
            // Fallback on earlier versions
        }
        return .init(white: 0.2, alpha: 1)
    }
    
    var dynamicPrimaryLabelColor: UIColor {
        return dynamicColor.withAlphaComponent(0.75)
    }
    var dynamicSecondaryLabelColor: UIColor {
        return dynamicColor.withAlphaComponent(0.6)
    }
    
}
