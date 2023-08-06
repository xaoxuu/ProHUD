//
//  SheetWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit


private extension Sheet {
    func getContextWindows() -> [SheetWindow] {
        guard let windowScene = windowScene else {
            return []
        }
        return AppContext.sheetWindows[windowScene] ?? []
    }
    func setContextWindows(_ windows: [SheetWindow]) {
        guard let windowScene = windowScene else {
            return
        }
        AppContext.sheetWindows[windowScene] = windows
    }
}

class SheetWindow: Window {
    
    var sheet: Sheet
    
    init(sheet: Sheet) {
        self.sheet = sheet
        if let scene = AppContext.windowScene {
            super.init(windowScene: scene)
        } else {
            super.init(frame: AppContext.appBounds)
        }
        sheet.window = self
        windowLevel = .init(rawValue: UIWindow.Level.alert.rawValue - 2)
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func push(sheet: Sheet) {
        let isNew: Bool
        let window: SheetWindow
        var windows = AppContext.current?.sheetWindows ?? []
        if let w = windows.first(where: { $0.sheet == sheet }) {
            isNew = false
            window = w
        } else {
            window = SheetWindow(sheet: sheet)
            isNew = true
        }
        window.rootViewController = sheet
        if windows.contains(window) == false {
            windows.append(window)
            sheet.setContextWindows(windows)
        }
        if isNew {
            sheet.navEvents[.onViewWillAppear]?(sheet)
            window.sheet.translateIn {
                sheet.navEvents[.onViewDidAppear]?(sheet)
            }
        } else {
            sheet.view.layoutIfNeeded()
        }
    }
    
    static func pop(sheet: Sheet) {
        var windows = sheet.getContextWindows()
        guard let window = windows.first(where: { $0.sheet == sheet }) else {
            return
        }
        sheet.navEvents[.onViewWillDisappear]?(sheet)
        window.sheet.translateOut { [weak window] in
            if let win = window {
                win.sheet.navEvents[.onViewDidDisappear]?(win.sheet)
                if windows.count > 1 {
                    windows.removeAll { $0 == win }
                } else if windows.count == 1 {
                    windows.removeAll()
                } else {
                    consolePrint("‼️代码漏洞：已经没有sheet了")
                }
                sheet.setContextWindows(windows)
            }
        }
    }
    
    
}
