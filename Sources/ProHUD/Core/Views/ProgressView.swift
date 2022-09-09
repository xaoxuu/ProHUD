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
