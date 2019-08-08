//
//  GuardView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

internal extension Guard {
    
    class Button: UIButton {
        class func actionButton(title: String?) -> Button {
            let btn = Button(type: .system)
            btn.setTitle(title, for: .normal)
            btn.layer.cornerRadius = cfg.guard.buttonCornerRadius
            btn.titleLabel?.font = cfg.guard.buttonFont
            return btn
        }
        
        func update(style: UIAlertAction.Style) {
            let pd = CGFloat(8)
            if style != .cancel {
                contentEdgeInsets = .init(top: pd*1.5+2, left: pd*1.5, bottom: pd*1.5+2, right: pd*1.5)
            } else {
                contentEdgeInsets = .init(top: pd*1+2, left: pd*1.5, bottom: pd*1+2, right: pd*1.5)
            }
            switch style {
            case .default:
                backgroundColor = tintColor
                setTitleColor(.white, for: .normal)
            case .destructive:
                backgroundColor = .init(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
                setTitleColor(.white, for: .normal)
            case .cancel:
                setTitleColor(cfg.secondaryLabelColor, for: .normal)
            @unknown default:
                break
            }
            tag = style.rawValue
        }
        
    }
}

