//
//  HUDView.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

// MARK: - public

public extension ProHUD {
    
    /// 堆栈视图容器
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
        /// 顺时针
        case clockwise = 1
        /// 逆时针
        case counterclockwise = -1
    }
    
    
    /// 进度指示器
    class ProgressView: UIView {
        
        var progressLayer = CAShapeLayer()
        
        override init(frame: CGRect) {
            // 容器宽度
            let maxSize = CGFloat(28)
            super.init(frame: .init(x: 0, y: 0, width: maxSize, height: maxSize))
            layer.cornerRadius = maxSize / 2
            layer.masksToBounds = true
            // 进度圆半径
            let radius = maxSize / 2 - 4
            backgroundColor = .white
            
            let path = UIBezierPath(arcCenter: CGPoint(x: 14, y: 14), radius: radius/2, startAngle: -CGFloat.pi*0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)
            
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.path = path.cgPath
            
            progressLayer.strokeColor = tintColor.cgColor
            progressLayer.lineWidth = radius
            progressLayer.strokeStart = 0
            progressLayer.strokeEnd = 0
            layer.addSublayer(progressLayer)
            
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func updateProgress(progress: CGFloat) {
            if progress <= 1 {
                // 初始化
                if progressLayer.superlayer == nil {
                    progressLayer.strokeEnd = 0
                    layer.addSublayer(progressLayer)
                }
                progressLayer.strokeEnd = progress
            }
        }
        
    }
    
}

// MARK: - internal

// MARK: 弹窗
internal extension Alert {
    
    /// 弹窗的按钮
    class Button: UIButton {
        
        /// 创建操作按钮
        /// - Parameter title: 标题
        /// - Returns: 按钮
        static func createActionButton(title: String?) -> Button {
            let btn = Button(type: .system)
            btn.setTitle(title, for: .normal)
            btn.layer.cornerRadius = cfg.alert.cornerRadius / 2
            btn.titleLabel?.font = cfg.alert.buttonFont
            return btn
        }
        
        /// 更新按钮
        /// - Parameter style: 样式
        func update(style: UIAlertAction.Style) {
            let pd = CGFloat(8)
            if style != .cancel {
                backgroundColor = cfg.dynamicColor.withAlphaComponent(0.04)
                contentEdgeInsets = .init(top: pd*1.5, left: pd*1.5, bottom: pd*1.5, right: pd*1.5)
            } else {
                backgroundColor = .clear
                contentEdgeInsets = .init(top: pd*1, left: pd*1.5, bottom: pd*1, right: pd*1.5)
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
        
        /// 创建隐藏按钮
        /// - Returns: 按钮
        static func createHideButton() -> UIButton {
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

// MARK: 操作表
internal extension Guard {
    
    /// 操作表的按钮
    class Button: UIButton {
        
        /// 创建操作按钮
        /// - Parameter title: 标题
        /// - Returns: 按钮
        static func createActionButton(title: String?) -> Button {
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

// MARK: - 动画

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
    
    /// 开始旋转
    /// - Parameters:
    ///   - direction: 方向
    ///   - speed: 速度
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
    
    /// 停止旋转
    func stopRotate() {
        removeAnimation(forKey: .rotateKey)
    }
    
}
