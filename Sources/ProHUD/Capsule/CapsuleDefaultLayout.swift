//
//  CapsuleDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension CapsuleTarget: DefaultLayout {
    
    var cfg: CommonConfiguration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        
        view.tintColor = vm.tintColor ?? config.tintColor
        
        // content
        loadContentViewIfNeeded()
        loadContentMaskViewIfNeeded()
        
        // image
        setupImageView()
        
        // text
        textLabel.removeFromSuperview()
        var text = [vm.title ?? "", vm.message ?? ""].filter({ $0.count > 0 }).joined(separator: " ")
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
    
    private func setupImageView() {
        // 移除动画
        stopRotate(animateLayer)
        animateLayer = nil
        animation = nil
        
        // 移除进度
        progressView?.removeFromSuperview()
        
        if vm.icon == nil && vm.iconURL == nil {
            contentStack.removeArrangedSubview(imageView)
        } else {
            contentStack.insertArrangedSubview(imageView, at: 0)
        }
        imageView.image = vm.icon
        if let iconURL = vm.iconURL {
            config.customWebImage?(imageView, iconURL)
        }
        if let rotation = vm.rotation {
            startRotate(rotation)
        }
        
    }
}
