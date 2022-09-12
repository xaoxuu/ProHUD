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
    public func update(handler: @escaping (_ toast: Toast) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ toast: Toast) -> Void)? = nil) -> [Toast] {
        let arr = ToastWindow.windows.compactMap({ $0.toast }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}
