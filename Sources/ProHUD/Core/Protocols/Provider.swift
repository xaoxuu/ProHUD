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

open class HUDProvider<ViewModel: HUDViewModelType, Target: HUDTargetType>: NSObject, HUDProviderType {
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码（传空值时不会做任何事）
    @discardableResult public required init(initializer: ((_ target: Target) -> Void)?) {
        guard let initializer = initializer else {
            // Provider的作用就是push一个target
            // 如果没有任何初始化代码就没有target，就是个无意义的Provider
            // 但为了支持lazyPush（找到已有实例并更新），所以就需要支持无意义的Provider
            // 详见子类中的 self.init(initializer: nil)
            return
        }
        var t = Target()
        initializer(t)
        t.push()
    }
    
}
