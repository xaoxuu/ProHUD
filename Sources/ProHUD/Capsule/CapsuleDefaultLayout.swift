//
//  CapsuleDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension Capsule: DefaultLayout {
    
    var cfg: ProHUD.Configuration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        
        // content
        loadContentViewIfNeeded()
        loadContentMaskViewIfNeeded()
        
        // image
        imageView.removeFromSuperview()
        if let icon = vm.icon {
            contentStack.insertArrangedSubview(imageView, at: 0)
            imageView.image = icon
        } else {
            contentStack.removeArrangedSubview(imageView)
        }
        
        // text
        textLabel.removeFromSuperview()
        let text = (vm.title ?? "") + (vm.message ?? "")
        if text.count > 0 {
            contentStack.addArrangedSubview(textLabel)
            textLabel.snp.makeConstraints { make in
                make.width.lessThanOrEqualTo(AppContext.appBounds.width * 0.5)
            }
            textLabel.text = text
            textLabel.sizeToFit()
        } else {
            contentStack.removeArrangedSubview(textLabel)
        }
        
        view.layoutIfNeeded()
        
        // 更新时间
        updateTimeoutDuration()
        
        if isViewDisplayed {
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    private func loadContentViewIfNeeded() {
        if contentView.superview != view {
            view.insertSubview(contentView, at: 0)
        }
        
        // layout
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard customView == nil else {
            if contentStack.superview != nil {
                contentStack.removeFromSuperview()
            }
            return
        }
        // stack
        if contentStack.superview == nil {
            view.addSubview(contentStack)
            contentStack.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
    }
    
    private func updateTimeoutDuration() {
        // 为空时使用默认规则
        if vm.duration == nil {
            vm.duration = 3
        }
        // 设置持续时间
        vm.timeoutHandler = DispatchWorkItem(block: { [weak self] in
            self?.pop()
        })
    }
    
}
