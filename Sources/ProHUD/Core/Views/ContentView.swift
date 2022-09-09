//
//  ContentView.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

public class ContentView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
