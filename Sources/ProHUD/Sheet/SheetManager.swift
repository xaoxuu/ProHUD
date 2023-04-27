//
//  SheetManager.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Sheet: HUD {
    
    public func push() {
        SheetWindow.push(sheet: self)
    }
    
    public func pop() {
        SheetWindow.pop(sheet: self)
    }
    
}

public extension Sheet {
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ sheet: Sheet) -> Void, onExists: ((_ sheet: Sheet) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Sheet { sheet in
                sheet.identifier = id
                handler(sheet)
            }
        }
    }
    
    /// 更新HUD实例
    /// - Parameter handler: 实例更新代码
    func update(handler: @escaping (_ sheet: Sheet) -> Void) {
        handler(self)
        reloadData()
        UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult static func find(identifier: String, update handler: ((_ sheet: Sheet) -> Void)? = nil) -> [Sheet] {
        let arr = SheetWindow.windows.compactMap({ $0.sheet }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}


extension Sheet {
    
    func translateIn(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
            self._translateIn()
        } completion: { done in
            completion?()
        }
    }
    
    func translateOut(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
            self._translateOut()
        } completion: { done in
            completion?()
        }
    }
    
    func _translateIn() {
        backgroundView.alpha = 1
        contentView.transform = .identity
    }
    
    func _translateOut() {
        backgroundView.alpha = 0
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + config.screenEdgeInset)
    }
    
}
