//
//  TableHeaderView.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/5.
//

import UIKit

class TableHeaderView: UIView {
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        lb.font = .systemFont(ofSize: 32, weight: .black)
        lb.textAlignment = .center
        lb.text = "ProHUD"
        return lb
    }()
    
    lazy var detailLabel: UILabel = {
        let lb = UILabel(frame: .init(x: 0, y: 80, width: UIScreen.main.bounds.width, height: 120))
        lb.font = .systemFont(ofSize: 15, weight: .regular)
        lb.textAlignment = .justified
        lb.numberOfLines = 0
        lb.text = "ProHUD"
        return lb
    }()
    
    convenience init(text: String) {
        self.init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        titleLabel.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(detailLabel)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(20)
        }
        detailLabel.snp.makeConstraints { make in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
