//
//  ToastManager.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

extension Toast: HUD {
    
    @objc open func push() {
        guard Configuration.isEnabled else { return }
        ToastWindow.push(toast: self)
    }
    
    @objc open func pop() {
        ToastWindow.pop(toast: self)
    }
    
}

public extension Toast {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ toast: Toast) -> Void, onExists: ((_ toast: Toast) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Toast { toast in
                toast.identifier = id
                handler(toast)
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter handler: 实例更新代码
    func update(handler: @escaping (_ toast: Toast) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult static func find(identifier: String, update handler: ((_ toast: Toast) -> Void)? = nil) -> [Toast] {
        let arr = AppContext.toastWindows.values.flatMap({ $0 }).compactMap({ $0.toast }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}
