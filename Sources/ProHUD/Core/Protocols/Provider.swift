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
    
    /// 根据ViewModel和自定义的初始化代码创建一个Target并显示
    /// - Parameters:
    ///   - vm: 数据模型
    ///   - initializer: 初始化代码
    @discardableResult init(_ vm: ViewModel?, initializer: ((_ target: Target) -> Void)?)
    
}

open class HUDProvider<ViewModel: HUDViewModelType, Target: HUDTargetType>: HUDProviderType {
    
    /// HUD实例
    public var target: Target
    
    /// 根据ViewModel和自定义的初始化代码创建一个Target并显示
    /// - Parameters:
    ///   - vm: 数据模型
    ///   - initializer: 初始化代码
    @discardableResult public required init(_ vm: ViewModel?, initializer: ((_ target: Target) -> Void)?) {
        var t = Target()
        if let vm = vm as? Target.ViewModel {
            t.vm = vm
        }
        initializer?(t)
        self.target = t
        if (vm == nil && initializer == nil) == false {
            DispatchQueue.main.async {
                t.push()
            }
        }
    }
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码
    @discardableResult public convenience init(initializer: ((_ target: Target) -> Void)?) {
        self.init(nil, initializer: initializer)
    }
    
    /// 根据ViewModel创建一个Target并显示
    /// - Parameter vm: 数据模型
    @discardableResult public convenience init(_ vm: ViewModel?) {
        self.init(vm, initializer: nil)
    }
    
    /// 创建一个空白的实例，不立即显示，需要手动调用target.push()来显示
    @discardableResult public convenience init() {
        self.init(nil, initializer: nil)
    }
    
    
}
