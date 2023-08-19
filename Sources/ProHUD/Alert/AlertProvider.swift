//
//  AlertProvider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

open class AlertProvider: HUDProvider<AlertViewModel, AlertTarget> {
    
    public typealias ViewModel = AlertViewModel
    public typealias Target = AlertTarget
    
    @discardableResult @objc public required init(initializer: ((_ alert: Target) -> Void)?) {
        super.init(initializer: initializer)
    }
    
    @discardableResult public convenience init(_ vm: ViewModel, initializer: ((_ alert: Target) -> Void)?) {
        self.init { alert in
            alert.vm = vm
            initializer?(alert)
        }
    }
    /// 根据ViewModel创建一个Target并显示
    /// - Parameter vm: 数据模型
    @discardableResult public convenience init(_ vm: ViewModel) {
        self.init(vm, initializer: nil)
    }
    
    @discardableResult @objc public convenience init(_ text: String, duration: TimeInterval = 3) {
        self.init(.message(text).duration(duration), initializer: nil)
    }
    
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ alert: AlertTarget) -> Void, onExists: ((_ alert: AlertTarget) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Self.init { alert in
                alert.identifier = id
                handler(alert)
            }
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ alert: AlertTarget) -> Void)? = nil) -> [AlertTarget] {
        let arr = AppContext.alertWindow.values.flatMap({ $0.alerts }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

public typealias Alert = AlertProvider
