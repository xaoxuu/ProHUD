//
//  HUDView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public extension ProHUD {
    
    class StackContainer: UIStackView {
        
        public override init(frame: CGRect) {
            super.init(frame: frame)
            spacing = cfg.alert.margin
            distribution = .fill
            alignment = .center
            axis = .vertical
            
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    /// 旋转方向
    enum RotateDirection: Double {
        case clockwise = 1
        case counterclockwise = -1
    }
    
}

internal extension String {
    static let rotateKey = "rotationAnimation"
}

internal extension Alert {
    class Button: UIButton {
        class func actionButton(title: String?) -> Button {
            let btn = Button(type: .system)
            btn.setTitle(title, for: .normal)
            btn.layer.cornerRadius = cfg.alert.cornerRadius / 2
            btn.titleLabel?.font = cfg.alert.buttonFont
            return btn
        }
        
        func update(style: UIAlertAction.Style) {
            let pd = CGFloat(8)
            if style != .cancel {
                backgroundColor = cfg.dynamicColor.withAlphaComponent(0.04)
                contentEdgeInsets = .init(top: pd*1.5, left: pd*1.5, bottom: pd*1.5, right: pd*1.5)
            } else {
                backgroundColor = .clear
                contentEdgeInsets = .init(top: pd*0.5, left: pd*1.5, bottom: pd*0.5, right: pd*1.5)
            }
            switch style {
            case .default:
                setTitleColor(tintColor, for: .normal)
            case .destructive:
                setTitleColor(.init(red: 244/255, green: 67/255, blue: 54/255, alpha: 1), for: .normal)
            case .cancel:
                setTitleColor(cfg.secondaryLabelColor, for: .normal)
            @unknown default:
                break
            }
            tag = style.rawValue
        }
        
        class func forceQuitButton() -> UIButton {
            let btn = Button(type: .system)
            let pd = cfg.alert.padding/2
            btn.contentEdgeInsets = .init(top: pd*1.5, left: pd*1.5, bottom: pd*1.5, right: pd*1.5)
            btn.imageEdgeInsets.right = pd*1.5
            btn.setTitleColor(UIColor(red:1.00, green:0.55, blue:0.21, alpha:1.00), for: .normal)
            btn.titleLabel?.font = cfg.alert.buttonFont
            return btn
        }
        
    }
    
}

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
                backgroundColor = .clear
                setTitleColor(cfg.secondaryLabelColor, for: .normal)
            @unknown default:
                break
            }
            tag = style.rawValue
        }
        
    }
}

internal extension UIView {
    
    private class func animateEaseOut(duration: TimeInterval = 1, delay: TimeInterval = 0, animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction, .curveEaseOut], animations: animations, completion: completion)
    }
    
    class func animateForAlertBuildIn(animations: @escaping () -> Void) {
        animateEaseOut(duration: 0.8, delay: 0, animations: animations, completion: nil)
    }
    class func animateForAlertBuildOut(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 0.38, delay: 0, animations: animations, completion: completion)
    }
    
    class func animateForAlert(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 1, delay: 0, animations: animations, completion: completion)
    }
    class func animateForAlert(animations: @escaping () -> Void) {
        animateForAlert(animations: animations, completion: nil)
    }
    
    class func animateForToast(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 1.2, delay: 0, animations: animations, completion: completion)
    }
    class func animateForToast(animations: @escaping () -> Void) {
        animateForToast(animations: animations, completion: nil)
    }
    
    class func animateForGuard(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        animateEaseOut(duration: 0.6, delay: 0, animations: animations, completion: completion)
    }
    class func animateForGuard(animations: @escaping () -> Void) {
        animateForGuard(animations: animations, completion: nil)
    }
    
}

extension CALayer {
    func startRotate(direction: ProHUD.RotateDirection, speed: CFTimeInterval) {
        if animation(forKey: .rotateKey) == nil {
            let ani = CABasicAnimation(keyPath: "transform.rotation.z")
            ani.toValue = direction.rawValue * Double.pi * 2.0
            if speed > 0 {
                ani.duration = 2 / speed
            }
            ani.repeatDuration = .infinity
            add(ani, forKey: .rotateKey)
        }
    }
    func endRotate() {
        removeAnimation(forKey: .rotateKey)
    }
}
