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
