//
//  ToastButton.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

public class ToastButton: Button {
    
    override var customEdgeInset: UIEdgeInsets {
        .init(top: 10, left: 24, bottom: 10, right: 24)
    }
    
    public override func update(config: ProHUD.Configuration, action: Action) {
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        layer.cornerRadiusWithContinuous = 8
        super.update(config: config, action: action)
    }
    
}

