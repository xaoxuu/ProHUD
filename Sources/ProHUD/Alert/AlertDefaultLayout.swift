//
//  AlertDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension AlertTarget: DefaultLayout {
    
    var cfg: CommonConfiguration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        view.tintColor = vm?.tintColor ?? config.tintColor
        let isFirstLayout: Bool
        if contentView.superview == nil {
            isFirstLayout = animated
            // 布局主容器视图
            loadContentViewIfNeeded()
        } else {
            isFirstLayout = false
        }
        // 更新时间
        updateTimeoutDuration()
        // custom layout
        guard customView == nil else {
            return
        }
        // default layout
        
        // 更新图片
        setupImageView()
        
        // 更新文本容器
        setupTextStack()
        
        // 更新操作容器
        reloadActionStack()
        contentStack.layoutIfNeeded()
        contentView.layoutIfNeeded()
        
        // 动画
        if animated {
            if isFirstLayout {
                view.layoutIfNeeded()
                imageView.transform = .init(scaleX: 0.7, y: 0.7)
                UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                    self.view.layoutIfNeeded()
                    self.imageView.transform = .identity
                }
            } else {
                UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            view.layoutIfNeeded()
        }
    }
    
    func loadContentViewIfNeeded() {
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        if contentView.superview != view {
            view.insertSubview(contentView, at: 0)
        }
        let alerts = attachedWindow?.alerts ?? []
        if config.enableShadow && alerts.count > 0 {
            contentView.clipsToBounds = false
            contentView.layer.shadowRadius = 4
            contentView.layer.shadowOpacity = 0.08
        }
        // custom layout
        guard customView == nil else {
            contentView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
            }
            return
        }
        // default layout
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            if customView == nil {
                make.width.greaterThanOrEqualTo(config.cardMinWidth)
                make.width.lessThanOrEqualTo(config.cardMaxWidthByDefault)
                make.height.greaterThanOrEqualTo(config.cardMinHeight)
                make.height.lessThanOrEqualTo(config.cardMaxHeightByDefault)
            }
        }
        if contentStack.superview == nil {
            contentView.addSubview(contentStack)
            let cardEdgeInsets = config.cardEdgeInsetsByDefault
            contentStack.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(cardEdgeInsets.top)
                make.left.equalToSuperview().inset(cardEdgeInsets.left)
                make.bottom.equalToSuperview().inset(cardEdgeInsets.bottom)
                make.right.equalToSuperview().inset(cardEdgeInsets.right)
            }
        }
        // card background
        if let mask = config.customContentViewMask {
            mask(contentMaskView)
            contentView.insertSubview(contentMaskView, at: 0)
            contentMaskView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            contentView.backgroundColor = config.dynamicBackgroundColor
        }
        
    }
    
    func setDefaultAxis() {
        guard isViewDisplayed == false && config.customActionStack == nil else { return }
        let count = actionStack.arrangedSubviews.filter({ $0.isKind(of: UIControl.self )}).count
        guard count < 4 else { return }
        if (isPortrait && count < 3) || !isPortrait {
            actionStack.axis = .horizontal
        }
    }
    
}

extension AlertTarget {
    
    func setupImageView() {
        // 移除动画
        stopRotate(animateLayer)
        animateLayer = nil
        animation = nil
        
        // 移除进度
        progressView?.removeFromSuperview()
        
        if vm?.icon != nil || vm?.iconURL != nil {
            imageView.image = vm?.icon
            if let iconURL = vm?.iconURL {
                config.customWebImage?(imageView, iconURL)
            }
            if imageView.superview == nil {
                contentStack.insertArrangedSubview(imageView, at: 0)
                let cardEdgeInsets = config.cardEdgeInsetsByDefault
                imageView.snp.remakeConstraints { (mk) in
                    mk.top.left.greaterThanOrEqualTo(contentView).inset(cardEdgeInsets.top * 2)
                    mk.right.bottom.lessThanOrEqualTo(contentView).inset(cardEdgeInsets.right * 2)
                    mk.width.equalTo(config.iconSize.width)
                    mk.height.equalTo(config.iconSize.height)
                }
            }
            if let rotation = vm?.rotation {
                startRotate(rotation)
            }
        } else {
            if contentStack.arrangedSubviews.contains(imageView) {
                contentStack.removeArrangedSubview(imageView)
            }
            imageView.removeFromSuperview()
        }
        
    }
    func setupTextStack() {
        let titleCount = vm?.title?.count ?? 0
        let bodyCount = vm?.message?.count ?? 0
        if titleCount > 0 || bodyCount > 0 {
            if textStack.superview != contentStack {
                if let index = contentStack.arrangedSubviews.firstIndex(of: imageView) {
                    contentStack.insertArrangedSubview(textStack, at: index + 1)
                } else {
                    contentStack.insertArrangedSubview(textStack, at: 0)
                }
                let cardEdgeInsets = config.cardEdgeInsetsByDefault
                textStack.snp.remakeConstraints { (mk) in
                    mk.left.greaterThanOrEqualToSuperview().inset(config.textEdgeInsets.left)
                    mk.right.lessThanOrEqualToSuperview().inset(config.textEdgeInsets.right)
                    mk.top.greaterThanOrEqualTo(contentView).inset(cardEdgeInsets.top + config.textEdgeInsets.top)
                    mk.bottom.lessThanOrEqualTo(contentView).inset(cardEdgeInsets.bottom + config.textEdgeInsets.bottom)
                }
            }
            if titleCount > 0 {
                titleLabel.text = vm?.title
                if titleLabel.superview != textStack {
                    textStack.insertArrangedSubview(titleLabel, at: 0)
                }
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
                bodyLabel.text = vm?.message
                if bodyLabel.superview != textStack {
                    textStack.addArrangedSubview(bodyLabel)
                }
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
        } else {
            textStack.removeFromSuperview()
        }
        textStack.layoutIfNeeded()
    }
    
    func reloadActionStack() {
        if actionStack.arrangedSubviews.count > 0 {
            if actionStack.superview == nil {
                contentStack.addArrangedSubview(actionStack)
                actionStack.snp.remakeConstraints {  (mk) in
                    mk.width.greaterThanOrEqualTo(180)
                    mk.left.right.equalToSuperview()
                }
            }
        } else {
            // 无按钮
            for v in actionStack.arrangedSubviews {
                v.removeFromSuperview()
            }
            actionStack.removeFromSuperview()
        }
        actionStack.layoutIfNeeded()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let alerts = attachedWindow?.alerts ?? []
        if config.enableShadow && alerts.count > 1 {
            contentView.layer.shadowPath = UIBezierPath.init(rect: contentView.bounds).cgPath
        }
    }
    
}
