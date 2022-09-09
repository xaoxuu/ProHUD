//
//  ToastManager.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

extension Toast: HUD {
    
    public func push() {
        ToastWindow.push(toast: self)
    }
    
    public func pop() {
        ToastWindow.pop(toast: self)
    }
    
}

extension Toast {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - callback: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, callback: @escaping (_ toast: Toast) -> Void) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = ToastWindow.windows.last(where: { $0.toast.identifier == id })?.toast {
            callback(vc)
            vc.reloadData()
        } else {
            Toast { hud in
                hud.identifier = id
                callback(hud)
            }.push()
        }
    }
    
    /// 更新HUD实例
    /// - Parameter callback: 实例更新代码
    public func update(callback: @escaping (_ toast: Toast) -> Void) {
        callback(self)
    }
    
    /// 更新HUD实例
    /// - Parameters:
    ///   - identifier: 唯一标识符
    ///   - callback: 实例更新代码
    public static func update(identifier: String, callback: @escaping (_ toast: Toast) -> Void) {
        guard let vc = ToastWindow.windows.last(where: { $0.toast.identifier == identifier })?.toast else {
            return
        }
        callback(vc)
        vc.reloadData()
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    public static func find(identifier: String) -> Toast? {
        guard let vc = ToastWindow.windows.last(where: { $0.toast.identifier == identifier })?.toast else {
            return nil
        }
        return vc
    }
    
}
