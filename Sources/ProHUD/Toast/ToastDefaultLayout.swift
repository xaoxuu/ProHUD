//
//  ToastDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension ToastTarget: DefaultLayout {
    
    var cfg: CommonConfiguration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        view.tintColor = vm?.tintColor ?? config.tintColor
        loadContentViewIfNeeded()
        loadContentMaskViewIfNeeded()
        guard customView == nil else {
            if contentStack.superview != nil {
                contentStack.removeFromSuperview()
            }
            return
        }
        let titleCount = vm?.title?.count ?? 0
        let bodyCount = vm?.message?.count ?? 0
        if vm?.icon != nil || vm?.iconURL != nil {
            if imageView.superview == nil {
                infoStack.insertArrangedSubview(imageView, at: 0)
                imageView.snp.makeConstraints { make in
                    if titleCount > 0 && bodyCount > 0 {
                        make.width.height.equalTo(config.iconSizeByDefault)
                    } else {
                        make.width.equalTo(config.iconSizeByDefault)
                    }
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
        if titleCount > 0 {
            textStack.insertArrangedSubview(titleLabel, at: 0)
            if bodyCount > 0 {
                config.customTitleLabel?(titleLabel)
            } else {
                if let customTextLabel = config.customTextLabel {
                    customTextLabel(titleLabel)
                } else {
                    titleLabel.font = .boldSystemFont(ofSize: 18)
                }
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
                if let customTextLabel = config.customTextLabel {
                    customTextLabel(bodyLabel)
                } else {
                    bodyLabel.font = .boldSystemFont(ofSize: 18)
                }
            }
        } else {
            if textStack.arrangedSubviews.contains(bodyLabel) {
                textStack.removeArrangedSubview(bodyLabel)
            }
            bodyLabel.removeFromSuperview()
        }
        // 设置数据
        titleLabel.text = vm?.title
        bodyLabel.text = vm?.message
        view.layoutIfNeeded()
        
        if isViewAppeared {
            // 更新时间
            updateTimeoutDuration()
        }
        
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
            let cardEdgeInsets = config.cardEdgeInsetsByDefault
            contentStack.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(cardEdgeInsets.top)
                make.left.equalToSuperview().inset(cardEdgeInsets.left)
                make.bottom.equalToSuperview().inset(cardEdgeInsets.bottom)
                make.right.equalToSuperview().inset(cardEdgeInsets.right)
            }
        }
        contentStack.insertArrangedSubview(infoStack, at: 0)
        
    }
    
}

extension ToastTarget {
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
        
        imageView.image = vm?.icon
        if let iconURL = vm?.iconURL {
            config.customWebImage?(imageView, iconURL)
        }
        if let rotation = vm?.rotation {
            startRotate(rotation)
        }
        
    }
    
}
