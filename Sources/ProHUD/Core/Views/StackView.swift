//
//  StackView.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

open class StackView: UIStackView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .fill
        alignment = .fill
        axis = .vertical
        spacing = 8
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(axis: NSLayoutConstraint.Axis) {
        self.init(frame: .zero)
        self.axis = axis
    }
    
}
