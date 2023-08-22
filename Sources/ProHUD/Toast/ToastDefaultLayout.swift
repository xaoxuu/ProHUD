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
        
        setupImageView()
        
        if isViewAppeared {
            // 更新时间
            updateTimeoutDuration()
            updateWindowSize()
        }
        
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
    
    func getWindowSize(window: ToastWindow) -> CGSize {
        let cardEdgeInsets = config.cardEdgeInsetsByDefault
        let width = CGFloat.minimum(AppContext.appBounds.width - config.marginX - config.marginX, config.cardMaxWidthByDefault)
        view.frame.size = CGSize(width: width, height: config.cardMaxHeightByDefault) // 以最大高度开始布局，然后计算实际需要高度
        titleLabel.sizeToFit()
        bodyLabel.sizeToFit()
        view.layoutIfNeeded()
        // 更新子视图之后获取正确的高度
        let height = calcHeight()
        let size = CGSize(width: width, height: height)
        view.frame.size = size
        view.layoutIfNeeded()
        return size
    }
    
    func updateWindowSize() {
        guard let window = view.window as? ToastWindow else { return }
        let lastSize = view.frame.size
        let newSize = getWindowSize(window: window)
        view.frame.size = lastSize
        view.layoutIfNeeded()
        window.frame.size = newSize
        ToastWindow.updateToastWindowsLayout()
    }
    
    private func calcHeight() -> CGFloat {
        var height = CGFloat(0)
        for v in infoStack.arrangedSubviews {
            // 图片或者文本最大高度
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        if actionStack.arrangedSubviews.count > 0 {
            height += actionStack.frame.height + contentStack.spacing
        }
        contentView.subviews.filter { v in
            if v == contentMaskView {
                return false
            }
            if v == contentStack {
                return false
            }
            return true
        } .forEach { v in
            height = CGFloat.maximum(v.frame.maxY, height)
        }
        // 上下边间距
        let cardEdgeInsets = config.cardEdgeInsetsByDefault
        height += cardEdgeInsets.top + cardEdgeInsets.bottom
        return height
    }
    
}
