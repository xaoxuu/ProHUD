//
//  Toast.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/24.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit


//public extension ProHUD {
//    class Toast: HUDController {
//        
//        public class View: UIView {
//            public var stack = UIStackView()
//            
//            public class Button: UIButton {
//                
//            }
//        }
//        
//        public convenience init(scene: HUDScene = .default, title: String?, message: String?, icon: UIImage?) {
//            self.init()
//            vm.scene = scene
//            vm.title = title
//            vm.message = message
//            vm.icon = icon
//            switch scene {
//            case .loading:
//                vm.timeout = nil
//            default:
//                vm.timeout = 2
//            }
//        }
//        
//        /// 设置超时时间
//        /// - Parameter timeout: 超时时间
//        public func timeout(_ timeout: TimeInterval?) -> Toast {
//            vm.timeout = timeout
//            return self
//        }
//        
//    }
//    
//    @discardableResult
//    func show(_ toast: Toast) -> Toast {
//        return toast
//    }
//    
//    @discardableResult
//    func showToast(scene: HUDScene = .default, title: String?, message: String?, icon: UIImage? = nil) -> Toast {
//        return ProHUD.shared.show(Toast(scene: scene, title: title, message: message, icon: icon))
//    }
//    
//    @discardableResult
//    class func showAlert(scene: HUDScene = .default, title: String?, message: String?, icon: UIImage? = nil) -> Toast {
//        return shared.showToast(scene: scene, title: title, message: message, icon: icon)
//    }
//    
//}
