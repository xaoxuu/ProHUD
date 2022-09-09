//
//  LoadingAnimation.swift
//  
//
//  Created by xaoxuu on 2022/9/1.
//

import UIKit

/// 加载动画
public protocol LoadingAnimation: Controller {
    
    var imageView: UIImageView { get }
    var progressView: ProgressView? { get set }
    
    /// 更新进度
    /// - Parameter progress: 进度百分比（0～1）
    func update(progress: CGFloat)
    
}
