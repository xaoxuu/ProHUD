//
//  GuardModel.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

public extension ProHUD.Guard {
    
    struct ViewModel {
        
        /// 标题
        public var title: String?
        
        /// 正文
        public var message: String?
        
        public init(title: String? = nil, message: String? = nil, icon: UIImage? = nil) {
            self.title = title
            self.message = message
        }
        
        
    }
    
}

