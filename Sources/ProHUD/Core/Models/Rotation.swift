//
//  Rotation.swift
//  
//
//  Created by xaoxuu on 2022/8/31.
//

import Foundation

public struct Rotation {
    
    /// 旋转方向
    public enum Direction: Double {
        /// 顺时针
        case clockwise = 1
        /// 逆时针
        case counterclockwise = -1
    }
    
    public var direction: Direction = .clockwise
    
    public var speed: CFTimeInterval = 2
    
    public var repeatCount: Float = .infinity
    
    public init(direction: Direction = .clockwise, speed: CFTimeInterval = 2, repeatCount: Float = .infinity) {
        self.direction = direction
        self.speed = speed
        self.repeatCount = repeatCount
    }
    
}
