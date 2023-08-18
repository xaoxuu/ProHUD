//
//  CapsuleViewModel.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

@objc open class CapsuleViewModel: BaseViewModel {
    
    @objc public enum Position: Int {
        case top
        case middle
        case bottom
    }
    
    @objc public var position: Position = .top
    
    public func position(position: Position) -> Self {
        self.position = position
        return self
    }
    public static var top: Self {
        let obj = Self.init()
        obj.position = .top
        return obj
    }
    public static var middle: Self {
        let obj = Self.init()
        obj.position = .middle
        return obj
    }
    public static var bottom: Self {
        let obj = Self.init()
        obj.position = .bottom
        return obj
    }
    
}
