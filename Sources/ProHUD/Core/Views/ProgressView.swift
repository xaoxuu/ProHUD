//
//  ProgressView.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

/// 进度指示器
public class ProgressView: UIView {
    
    var progressLayer = CAShapeLayer()
    
    static var lineWidth: CGFloat { 4 }
    
    public override var tintColor: UIColor! {
        didSet {
            progressLayer.strokeColor = tintColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        let lineWidth = Self.lineWidth
        // 容器宽度
        let size = CGFloat.maximum(frame.height, frame.width)
        super.init(frame: .init(x: 0, y: 0, width: size, height: size))
        layer.cornerRadius = size / 2
        layer.masksToBounds = true
        // 圆环路径
        let path = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: (size - lineWidth) / 2, startAngle: -CGFloat.pi*0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)
        
        // 轨道
        let bgLayer = CAShapeLayer()
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.path = path.cgPath
        bgLayer.strokeColor = UIColor.white.cgColor
        bgLayer.lineWidth = lineWidth
        bgLayer.lineCap = .round
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        layer.addSublayer(bgLayer)
        
        // 进度
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = tintColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
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
