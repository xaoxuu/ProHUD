//
//  DefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

protocol DefaultLayout: CommonLayout {
    
    var cfg: Configuration { get }
    
    func reloadDataByDefault()
    
    func loadContentViewIfNeeded()
    
}

extension DefaultLayout {
    func loadContentMaskViewIfNeeded() {
        guard contentMaskView.superview != contentView else {
            return
        }
        if let mask = cfg.customContentViewMask {
            mask(contentMaskView)
        } else {
            contentMaskView.effect = .none
            contentMaskView.backgroundColor = cfg.dynamicBackgroundColor
        }
        contentView.insertSubview(contentMaskView, at: 0)
        contentView.backgroundColor = .clear
        contentMaskView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

