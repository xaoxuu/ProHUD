//
//  TimeProgress.swift
//  
//
//  Created by xaoxuu on 2023/8/25.
//

import UIKit

public class TimeProgress: NSObject {

    public var total: TimeInterval
    
    public var current: TimeInterval
    
    // 每秒10跳
    var interval: TimeInterval = 0.1
    
    public var direction: TimeDirection
    
    public var percent: CGFloat {
        guard total > 0 else { return 0 }
        return current / total
    }
    
    public var isFinish: Bool {
        switch direction {
        case .clockwise:
            return current >= total
        case .counterclockwise:
            return current <= 0
        }
    }
    
    init(total: TimeInterval, direction: TimeDirection = .clockwise, onUpdate: ((_ progress: TimeProgress) -> Void)? = nil, onCompletion: (() -> Void)? = nil) {
        self.total = total
        self.direction = direction
        switch direction {
        case .clockwise:
            // 顺时针从0开始
            self.current = 0
        case .counterclockwise:
            // 逆时针（倒计时）从total开始
            self.current = total
        }
        self.onUpdate = onUpdate
        self.onCompletion = onCompletion
    }
    
    func next() {
        switch direction {
        case .clockwise:
            current = min(total, current + interval)
        case .counterclockwise:
            current = max(0, current - interval)
        }
        onUpdate?(self)
        if isFinish {
            onCompletion?()
        }
    }
    
    func set(newPercent: CGFloat) {
        current = total * newPercent
    }
    
    var onUpdate: ((_ progress: TimeProgress) -> Void)?
    var onCompletion: (() -> Void)?
    
}
