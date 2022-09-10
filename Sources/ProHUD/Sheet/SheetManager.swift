//
//  SheetManager.swift
//  
//
//  Created by xaoxuu on 2022/9/8.
//

import UIKit

extension Sheet: HUD {
    
    public func push() {
        SheetWindow.push(sheet: self)
    }
    
    public func pop() {
        SheetWindow.pop(sheet: self)
    }
    
}

extension Sheet {
    
    func translateIn(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildInByDefault) {
            self._translateIn()
        } completion: { done in
            completion?()
        }
    }
    
    func translateOut(completion: (() -> Void)?) {
        UIView.animateEaseOut(duration: config.animateDurationForBuildOutByDefault) {
            self._translateOut()
        } completion: { done in
            completion?()
        }
    }
    
    func _translateIn() {
        backgroundView.alpha = 1
        contentView.transform = .identity
    }
    
    func _translateOut() {
        backgroundView.alpha = 0
        contentView.transform = .init(translationX: 0, y: view.frame.size.height - contentView.frame.minY + config.margin)
    }
    
}
