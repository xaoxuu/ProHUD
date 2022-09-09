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
