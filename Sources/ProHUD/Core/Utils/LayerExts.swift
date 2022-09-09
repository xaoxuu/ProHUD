//
//  LayerExts.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import UIKit

// MARK: 圆角

extension CALayer {
    var cornerRadiusWithContinuous: CGFloat {
        set {
            cornerRadius = newValue
            if #available(iOS 13.0, *) {
                cornerCurve = .continuous
            } else {
                // Fallback on earlier versions
            }
        }
        get { cornerRadius }
    }
}

// MARK: - 旋转动画

extension String {
    static let rotateKey = "rotationAnimation"
}

extension CALayer {
    
    /// 开始旋转
    /// - Parameters:
    ///   - direction: 方向
    ///   - speed: 速度
    func startRotate(_ rotate: Rotation) {
        if animation(forKey: .rotateKey) == nil {
            let ani = CABasicAnimation(keyPath: "transform.rotation.z")
            ani.toValue = rotate.direction.rawValue * Double.pi * 2.0
            if speed > 0 {
                ani.duration = 2 / rotate.speed
            }
            ani.repeatCount = rotate.repeatCount
            add(ani, forKey: .rotateKey)
        }
    }
    
    /// 停止旋转
    func stopRotate() {
        removeAnimation(forKey: .rotateKey)
    }
    
}
