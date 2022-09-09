//
//  CommonLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import Foundation

public protocol CommonLayout: Controller {
    func reloadData()
}

public extension CommonLayout {
    
    func reloadData() {
        guard let self = self as? DefaultLayout else {
            return
        }
        if self.cfg.customReloadData?(self) == true {
            return
        }
        self.reloadDataByDefault()
    }
    
}

extension CommonLayout {
    
}
