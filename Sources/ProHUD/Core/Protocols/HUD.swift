//
//  ProHUD.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public protocol HUD {
    func push()
    func push(workspace: Workspace?)
    func pop()
}

public extension HUD {
    func push(workspace: Workspace?) {
        AppContext.workspace = workspace
        push()
    }
}
