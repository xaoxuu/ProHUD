//
//  File.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

class SheetWindow: Window {
    
    static var windows = [SheetWindow]()
    
    var sheet: Sheet
    
    init(sheet: Sheet) {
        self.sheet = sheet
        super.init(frame: .zero)
        if #available(iOS 13.0, *) {
            windowScene = sheet.config.windowScene ?? UIApplication.shared.windows.last?.windowScene
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
        if let w = windows.first(where: { $0.sheet == sheet }) {
            isNew = false
            window = w
        } else {
            window = SheetWindow(sheet: sheet)
            isNew = true
        }
        window.rootViewController = sheet // 此时toast.view.frame.size会自动更新为window.frame.size
        if windows.contains(window) == false {
            windows.append(window)
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
            }
        }
    }
    
    
}
