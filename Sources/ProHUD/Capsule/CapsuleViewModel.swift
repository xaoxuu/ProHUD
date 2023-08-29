//
//  CapsuleViewModel.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

@objc open class CapsuleViewModel: BaseViewModel {
    
    @objc(CapsulePosition) public enum Position: Int {
        case top
        case middle
        case bottom
    }
    
    @objc public var position: Position = .top
    
    // Capsule 在一个位置最多只显示一个实例
    // queuedPush: false 如果已有就直接覆盖
    // queuedPush: true  如果已有就排队等待
    @objc public var queuedPush: Bool = false
    
}

public extension CapsuleViewModel {
    
    @discardableResult
    @objc func position(_ position: Position) -> Self {
        self.position = position
        return self
    }
    static var top: Self {
        let obj = Self.init()
        obj.position = .top
        return obj
    }
    static var middle: Self {
        let obj = Self.init()
        obj.position = .middle
        return obj
    }
    static var bottom: Self {
        let obj = Self.init()
        obj.position = .bottom
        return obj
    }
    
    func queuedPush(_ queuedPush: Bool) -> Self {
        self.queuedPush = queuedPush
        return self
    }
    
}
