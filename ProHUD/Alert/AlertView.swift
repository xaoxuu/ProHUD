//
//  AlertView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD.Alert {
    
    
}

extension UIButton {
    class func hideButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        btn.setImage(ProHUD.image(named: "ProHUDMinimize"), for: .normal)
        btn.layer.shadowOpacity = 0.15
        btn.layer.shadowOffset = .init(width: 0, height: 1.2)
        btn.layer.shadowRadius = 1.2
        btn.alpha = 0
        btn.transform = .init(scaleX: 0.5, y: 0.5)
        UIView.animateFastEaseOut(delay: 0, animations: {
            btn.alpha = 1
            btn.transform = .identity
        }) { (done) in
        }
        return btn
    }
    class func actionButton(style: UIAlertAction.Style, title: String?) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.layer.cornerRadius = alertConfig.cornerRadius / 2
        btn.titleLabel?.font = alertConfig.buttonFont
        btn.update(style: style)
        return btn
    }
    
    func update(style: UIAlertAction.Style) {
        let pd = alertConfig.padding/2
        if style != .cancel {
            backgroundColor = .init(white: 0, alpha: 0.04)
            contentEdgeInsets = .init(top: pd*1.5, left: pd*1.5, bottom: pd*1.5, right: pd*1.5)
        } else {
            contentEdgeInsets = .init(top: pd*0.5, left: pd*1.5, bottom: pd*0.5, right: pd*1.5)
        }
        switch style {
        case .default:
            setTitleColor(tintColor, for: .normal)
        case .destructive:
            setTitleColor(.init(red: 244/255, green: 67/255, blue: 54/255, alpha: 1), for: .normal)
        case .cancel:
            setTitleColor(.darkGray, for: .normal)
        @unknown default:
            break
        }
        tag = style.rawValue
    }
    
}
