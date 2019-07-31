//
//  Guard.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/24.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

//public extension ProHUD {
//    class Guard: Element {
//        
//        public class View: UIView {
//            public var stack = UIStackView()
//            
//            public class Button: UIButton {
//                
//            }
//        }
//        
//        
//        public convenience init(title: String? = nil, message: String? = nil) {
//            self.init()
//            vm.title = title
//            vm.message = message
//        }
//        
//        public override func viewDidDisappear(_ animated: Bool) {
//            vm.disappearCallback?()
//        }
//        
//    }
//    
//    
//    @discardableResult
//    func show(_ guard: Guard) -> Guard {
//        return `guard`
//    }
//    
//    @discardableResult
//    func showGuard(title: String? = nil, message: String? = nil) -> Guard {
//        return ProHUD.shared.show(Guard(title: title, message: message))
//    }
//    
//    @discardableResult
//    class func showGuard(title: String? = nil, message: String? = nil) -> Guard {
//        return shared.showGuard(title: title, message: message)
//    }
//    
//}
//
//public extension ProHUD.Guard {
//    
//    @discardableResult
//    func addAction(style: UIAlertAction.Style, title: String?, didTapped: ((View.Button) -> Void)?) -> ProHUD.Guard {
//        
//        return self
//    }
//    
//    @discardableResult
//    func addAction(custom: (View.Button) -> Void, didTapped: ((View.Button) -> Void)?) -> ProHUD.Guard {
//       
//        return self
//    }
//    
//    @discardableResult
//    func didDisappear(_ callback: (() -> Void)?) -> ProHUD.Guard {
//        vm.disappearCallback = callback
//        return self
//    }
//    
//}
