//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

extension LoadingAnimation {
    
    /// 更新进度（如果需要显示进度，需要先调用一次 updateProgress(0) 来初始化）
    /// - Parameter progress: 进度（0~1）
    public func update(progress: CGFloat) {
        guard isViewLoaded else { return }
        guard let superview = imageView.superview else { return }
        if progressView == nil {
            let width = imageView.frame.size.width + ProgressView.lineWidth * 2
            let v = ProgressView(frame: .init(origin: .zero, size: .init(width: width, height: width)))
            superview.addSubview(v)
            v.tintColor = superview.tintColor
            v.snp.remakeConstraints { (mk) in
                mk.center.equalTo(imageView)
                mk.width.height.equalTo(width)
            }
            progressView = v
        }
        if let v = progressView {
            v.updateProgress(progress: progress)
        }
    }
    
    /// 旋转动画
    /// - Parameters:
    ///   - layer: 图层
    ///   - direction: 方向
    ///   - speed: 速度
    func startRotate(_ rotate: Rotation, at layer: CALayer? = nil) {
        DispatchQueue.main.async {
            let l = layer ?? self.imageView.layer
            self.animateLayer = l
            l.startRotate(rotate)
            NotificationCenter.default.addObserver(self, selector: #selector(self.pauseLoadingAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.resumeLoadingAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    /// 停止旋转
    /// - Parameter layer: 图层
    func stopRotate(_ layer: CALayer? = nil) {
        DispatchQueue.main.async {
            self.animateLayer = nil
            (layer ?? self.imageView.layer)?.stopRotate()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
}

/// 动画扩展
extension Controller {
    @objc func pauseLoadingAnimation() {
        if let layer = animateLayer {
            animation = layer.animation(forKey: .rotateKey)
            layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
        }
    }
    @objc func resumeLoadingAnimation() {
        if let layer = animateLayer, let ani = animation, layer.speed == 0 {
            let pauseTime = layer.timeOffset
            layer.timeOffset = 0
            let beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
            layer.beginTime = beginTime
            layer.speed = 1
            layer.add(ani, forKey: .rotateKey)
        }
    }
}

