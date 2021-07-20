//
//  HUDUtils.swift
//  ProHUD
//
//  Created by xaoxuu on 2020/6/22.
//  Copyright © 2020 Titan Studio. All rights reserved.
//

import UIKit
import Inspire

extension String {
    static let rotateKey = "rotationAnimation"
}

extension ProHUD {
    static var safeAreaInsets: UIEdgeInsets {
        Inspire.shared.screen.safeAreaInsets
    }
}


func == (left: ProHUD.Scene, right: ProHUD.Scene) -> Bool {
    left.identifier == right.identifier
}


func != (left: ProHUD.Scene, right: ProHUD.Scene) -> Bool {
    left.identifier != right.identifier
}
