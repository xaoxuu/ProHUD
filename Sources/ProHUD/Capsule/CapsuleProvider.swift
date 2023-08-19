//
//  CapsuleProvider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

open class CapsuleProvider: HUDProvider<CapsuleViewModel, CapsuleTarget> {
    
    public typealias ViewModel = CapsuleViewModel
    public typealias Target = CapsuleTarget
    
    @discardableResult @objc public required init(initializer: ((_ capsule: Target) -> Void)?) {
        super.init(initializer: initializer)
    }
    
    /// 根据ViewModel和自定义的初始化代码创建一个Target并显示
    /// - Parameters:
    ///   - vm: 数据模型
    ///   - initializer: 初始化代码
    @discardableResult public convenience init(_ vm: ViewModel, initializer: ((_ capsule: Target) -> Void)?) {
        self.init { capsule in
            capsule.vm = vm
            initializer?(capsule)
        }
    }
    
    /// 根据ViewModel创建一个Target并显示
    /// - Parameter vm: 数据模型
    @discardableResult public convenience init(_ vm: ViewModel) {
        self.init(vm, initializer: nil)
    }
    
    @discardableResult public convenience init(_ text: String) {
        self.init(.message(text), initializer: nil)
    }
    
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ capsule: CapsuleTarget) -> Void, onExists: ((_ capsule: CapsuleTarget) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Self.init { capsule in
                capsule.identifier = id
                handler(capsule)
            }
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ capsule: CapsuleTarget) -> Void)? = nil) -> [CapsuleTarget] {
        let arr = AppContext.capsuleWindows.values.flatMap({ $0.values }).compactMap({ $0.capsule }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

public typealias Capsule = CapsuleProvider
