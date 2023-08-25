//
//  Rotation.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import Foundation

public struct Rotation {
    
    /// 旋转方向
    public var direction: TimeDirection = .clockwise
    
    public var speed: CFTimeInterval = 2
    
    public var repeatCount: Float = .infinity
    
    public init(direction: TimeDirection = .clockwise, speed: CFTimeInterval = 2, repeatCount: Float = .infinity) {
        self.direction = direction
        self.speed = speed
        self.repeatCount = repeatCount
    }
    
}

public extension Rotation {
    static var infinity: Self {
        .init(direction: .clockwise, speed: 2, repeatCount: .infinity)
    }
}
