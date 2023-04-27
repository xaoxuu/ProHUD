//
//  SheetButton.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

public class SheetButton: Button {
    
    override var customEdgeInset: UIEdgeInsets {
        .init(top: 14, left: 28, bottom: 14, right: 28)
    }
    
    public override func update(config: ProHUD.Configuration, action: Action) {
        titleLabel?.font = .boldSystemFont(ofSize: 18)
        layer.cornerRadiusWithContinuous = 12
        super.update(config: config, action: action)
    }
    
}
