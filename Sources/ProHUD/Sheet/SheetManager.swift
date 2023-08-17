//
//  SheetManager.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Sheet: HUD {
    
    @objc open func push() {
        guard Configuration.isEnabled else { return }
        let isNew: Bool
        let window: SheetWindow
        var windows = AppContext.current?.sheetWindows ?? []
        if let w = windows.first(where: { $0.sheet == self }) {
            isNew = false
            window = w
        } else {
            window = SheetWindow(sheet: self)
            isNew = true
        }
        window.rootViewController = self
        if windows.contains(window) == false {
            windows.append(window)
            setContextWindows(windows)
        }
        if isNew {
            navEvents[.onViewWillAppear]?(self)
            window.sheet.translateIn { [weak self] in
                guard let self = self else { return }
                self.navEvents[.onViewDidAppear]?(self)
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    @objc open func pop() {
        var windows = getContextWindows()
        guard let window = windows.first(where: { $0.sheet == self }) else {
            return
        }
        navEvents[.onViewWillDisappear]?(self)
        window.sheet.translateOut { [weak window, weak self] in
            guard let self = self, let win = window else { return }
            win.sheet.navEvents[.onViewDidDisappear]?(win.sheet)
            if windows.count > 1 {
                windows.removeAll { $0 == win }
            } else if windows.count == 1 {
                windows.removeAll()
            } else {
                consolePrint("‼️代码漏洞：已经没有sheet了")
            }
            self.setContextWindows(windows)
        }
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
        let arr = AppContext.sheetWindows.values.flatMap({ $0 }).compactMap({ $0.sheet }).filter({ $0.identifier == identifier })
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
            if self.config.stackDepthEffect {
                if isPhonePortrait {
                    AppContext.appWindow?.transform = .init(translationX: 0, y: 8).scaledBy(x: 0.9, y: 0.9)
                } else {
                    AppContext.appWindow?.transform = .init(scaleX: 0.92, y: 0.92)
                }
                AppContext.appWindow?.layer.cornerRadiusWithContinuous = 16
                AppContext.appWindow?.layer.masksToBounds = true
            }
        } completion: { done in
            completion?()
        }
    }
    
    func translateOut(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
            self._translateOut()
            if self.config.stackDepthEffect {
                AppContext.appWindow?.transform = .identity
                AppContext.appWindow?.layer.cornerRadius = 0
            }
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
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + config.windowEdgeInset)
    }
    
}
