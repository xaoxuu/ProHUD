//
//  ToastProvider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

open class ToastProvider: HUDProvider<ToastViewModel, ToastTarget> {
    @discardableResult public required init(_ vm: ViewModel?, initializer: ((_ toast: Target) -> Void)?) {
        super.init(vm, initializer: initializer)
    }
    
    @discardableResult public required convenience init(initializer: ((_ toast: Target) -> Void)?) {
        self.init(nil, initializer: initializer)
    }
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ toast: ToastTarget) -> Void, onExists: ((_ toast: ToastTarget) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Self.init { toast in
                toast.identifier = id
                handler(toast)
            }
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ toast: ToastTarget) -> Void)? = nil) -> [ToastTarget] {
        let arr = AppContext.toastWindows.values.flatMap({ $0 }).compactMap({ $0.toast }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

public typealias Toast = ToastProvider
