//
//  GuardView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

internal extension ProHUD.Guard {
    class View: UIView {
        
        override func willMove(toSuperview newSuperview: UIView?) {
            if let sv = newSuperview {
                for v in sv.subviews {
                    if let vv = v as? ProHUD.Guard.View {
                        if vv.tag == self.tag {
                            UIView.animate(withDuration: 0.38, delay: 0.1, options: .curveEaseIn, animations: {
                                vv.alpha = 0
                            }) { (done) in
                                vv.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
        
//        override func didMoveToSuperview() {
//            if let _ = superview {
//                snp.makeConstraints { (mk) in
////                    mk.left.right.bottom.equalToSuperview()
//                    mk.edges.equalToSuperview()
//                }
////                push(duration: duration)
//            }
//        }
        
    }
    class Button: UIButton {
        class func actionButton(title: String?) -> Button {
            let btn = Button(type: .system)
            btn.setTitle(title, for: .normal)
            btn.layer.cornerRadius = guardConfig.buttonCornerRadius
            btn.titleLabel?.font = guardConfig.buttonFont
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
                setTitleColor(UIColorForSecondaryLabel, for: .normal)
            @unknown default:
                break
            }
            tag = style.rawValue
        }
        
    }
}

