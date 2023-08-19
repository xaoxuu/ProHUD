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

open class HUDProvider<ViewModel: HUDViewModelType, Target: HUDTargetType>: HUDProviderType {
    
    /// HUD实例
    public var target: Target
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码
    @discardableResult public required init(initializer: ((_ target: Target) -> Void)?) {
        var t = Target()
        initializer?(t)
        self.target = t
        if (t.vm == nil && initializer == nil) == false {
            DispatchQueue.main.async {
                t.push()
            }
        }
    }
    
    /// 创建一个空白的实例，不立即显示，需要手动调用target.push()来显示
    @discardableResult public convenience init() {
        self.init(initializer: nil)
    }
    
    
}
