//
//  AlertButton.swift
//  
//
//  Created by xaoxuu on 2023/4/27.
//

import UIKit

public class AlertButton: Button {
    
    override var customEdgeInset: UIEdgeInsets {
        .init(top: 12, left: 24, bottom: 12, right: 24)
    }
    
    public override func update(config: ProHUD.Configuration, action: Action) {
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        layer.cornerRadiusWithContinuous = 8
        super.update(config: config, action: action)
    }
    
}


