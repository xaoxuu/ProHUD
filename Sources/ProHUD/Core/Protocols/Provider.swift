//
//  Provider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

public protocol HUDProviderType {
    
    associatedtype ViewModel = HUDViewModelType
    associatedtype Target = HUDTargetType
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码
    @discardableResult init(initializer: ((_ target: Target) -> Void)?)
    
}

