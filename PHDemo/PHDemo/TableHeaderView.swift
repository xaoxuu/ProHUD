//
//  TableHeaderView.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/5.
//

import UIKit

class TableHeaderView: UIView {
    
    lazy var detailLabel: UILabel = {
        let lb = UILabel(frame: .init(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 80))
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.textAlignment = .justified
        lb.numberOfLines = 0
        lb.text = "ProHUD"
        return lb
    }()
    
    convenience init() {
        self.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(detailLabel)
        
        detailLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(8)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
