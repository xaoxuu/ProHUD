//
//  ToastDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension Toast: DefaultLayout {
    
    var cfg: ProHUD.Configuration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        loadContentViewIfNeeded()
        loadContentMaskViewIfNeeded()
        guard customView == nil else {
            if contentStack.superview != nil {
                contentStack.removeFromSuperview()
            }
            return
        }
        if vm.icon != nil {
            if imageView.superview == nil {
                infoStack.insertArrangedSubview(imageView, at: 0)
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(config.iconSize)
                }
            }
        } else {
            if infoStack.arrangedSubviews.contains(imageView) {
                infoStack.removeArrangedSubview(imageView)
            }
            imageView.removeFromSuperview()
        }
        if textStack.superview == nil {
            infoStack.addArrangedSubview(textStack)
        }
        let titleCount = vm.title?.count ?? 0
        let bodyCount = vm.message?.count ?? 0
        if titleCount > 0 {
            textStack.insertArrangedSubview(titleLabel, at: 0)
            if bodyCount > 0 {
                config.customTitleLabel?(titleLabel)
            } else {
                config.customTextLabel?(bodyLabel)
            }
        } else {
            if textStack.arrangedSubviews.contains(titleLabel) {
                textStack.removeArrangedSubview(titleLabel)
            }
            titleLabel.removeFromSuperview()
        }
        if bodyCount > 0 {
            textStack.addArrangedSubview(bodyLabel)
            if titleCount > 0 {
                config.customBodyLabel?(bodyLabel)
            } else {
                config.customTextLabel?(bodyLabel)
            }
        } else {
            if textStack.arrangedSubviews.contains(bodyLabel) {
                textStack.removeArrangedSubview(bodyLabel)
            }
            bodyLabel.removeFromSuperview()
        }
        // 设置数据
        imageView.image = vm.icon
        titleLabel.text = vm.title
        bodyLabel.text = vm.message
        view.layoutIfNeeded()
        
        // 设置持续时间
        vm.timeoutHandler = DispatchWorkItem(block: { [weak self] in
            self?.pop()
        })
        
        setupImageView()
        
    }
    
    func loadContentViewIfNeeded() {
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        guard contentView.superview != view else {
            return
        }
        view.addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        // stacks
        if contentStack.superview != contentView {
            contentView.addSubview(contentStack)
            contentStack.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(config.cardEdgeInsets.top)
                make.left.equalToSuperview().inset(config.cardEdgeInsets.left)
                make.bottom.equalToSuperview().inset(config.cardEdgeInsets.bottom)
                make.right.equalToSuperview().inset(config.cardEdgeInsets.right)
            }
        }
        contentStack.insertArrangedSubview(infoStack, at: 0)
        
    }
    
}

extension Toast {
    func loadActionStackIfNeeded() {
        guard actionStack.arrangedSubviews.count > 0 else {
            actionStack.removeFromSuperview()
            return
        }
        if actionStack.superview == nil {
            let sup = StackView()
            sup.alignment = .trailing
            sup.addArrangedSubview(actionStack)
            contentStack.addArrangedSubview(sup)
        }
    }
    
    func setupImageView() {
        // 移除动画
        stopRotate(animateLayer)
        animateLayer = nil
        animation = nil
        
        // 移除进度
        progressView?.removeFromSuperview()
        
        imageView.image = vm.icon
        if let rotation = vm.rotation {
            startRotate(rotation)
        }
        
    }
}
