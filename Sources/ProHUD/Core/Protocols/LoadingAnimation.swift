//
//  LoadingAnimation.swift
//  
//
//  Created by xaoxuu on 2022/9/1.
//

import UIKit

/// 加载动画
public protocol LoadingAnimation: BaseController {
    
    var imageView: UIImageView { get }
    var progressView: ProgressView? { get set }
    
}
