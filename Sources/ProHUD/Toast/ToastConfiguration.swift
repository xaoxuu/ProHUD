//
//  ToastConfiguration.swift
//  
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

public extension Toast {
    
    class Configuration: ProHUD.Configuration {
        
        /// 行间距
        public var lineSpace = CGFloat(4)
        
        static var customShared: ((_ config: Configuration) -> Void)?
        
        /// 共享配置（只能设置一次，影响所有实例）
        /// - Parameter callback: 配置代码
        public static func shared(_ callback: @escaping (_ config: Configuration) -> Void) {
            customShared = callback
        }
        
        override var cardMaxWidthByDefault: CGFloat {
            cardMaxWidth ?? 500
        }
        
        override var cardMaxHeightByDefault: CGFloat {
            cardMaxHeight ?? (UIScreen.main.bounds.height / 3)
        }
        
        override var titleFontByDefault: UIFont {
            titleFont ?? .systemFont(ofSize: 19, weight: .bold)
        }
        
        override var boldTextFontByDefault: UIFont {
            boldTextFont ?? .systemFont(ofSize: 17, weight: .bold)
        }
        
        override var bodyFontByDefault: UIFont {
            bodyFont ?? .systemFont(ofSize: 17, weight: .regular)
        }
        
        override var animateDurationForBuildInByDefault: CGFloat {
            animateDurationForBuildIn ?? 0.8
        }
        
        override var animateDurationForBuildOutByDefault: CGFloat {
            animateDurationForBuildIn ?? 0.8
        }
        
    }
    
}

