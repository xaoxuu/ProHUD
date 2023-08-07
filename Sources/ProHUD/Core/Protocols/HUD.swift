//
//  ProHUD.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

@objc public protocol HUD {
    @objc func push()
    @objc func pop()
}

//public extension HUD {
//    func push(workspace: Workspace?) {
//        AppContext.workspace = workspace
//        push()
//    }
//}
