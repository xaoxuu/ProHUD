//
//  SheetWindow.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

class SheetWindow: Window {
    
    var sheet: SheetTarget
    
    init(sheet: SheetTarget) {
        self.sheet = sheet
        if let scene = AppContext.windowScene {
            super.init(windowScene: scene)
        } else {
            super.init(frame: AppContext.appBounds)
        }
        sheet.window = self
        windowLevel = .phSheet
        isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SheetTarget {
    func getContextWindows() -> [SheetWindow] {
        guard let windowScene = windowScene ?? AppContext.windowScene else {
            return []
        }
        return AppContext.sheetWindows[windowScene] ?? []
    }
    func setContextWindows(_ windows: [SheetWindow]) {
        guard let windowScene = windowScene ?? AppContext.windowScene else {
            return
        }
        AppContext.sheetWindows[windowScene] = windows
    }
}
