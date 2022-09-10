//
//  AlertDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension Alert: DefaultLayout {
    
    var cfg: ProHUD.Configuration {
        return config
    }
    
    func reloadDataByDefault() {
        let isFirstLayout: Bool
        if contentView.superview == nil {
            isFirstLayout = true
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
        // id 包含 .rotate 的会自动旋转
        if let rotation = vm.rotation {
            startRotate(rotation)
        }
        // 设置持续时间
        vm.timeoutHandler = DispatchWorkItem(block: { [weak self] in
            self?.pop()
        })
        
    }
    
    func loadContentViewIfNeeded() {
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        if contentView.superview != view {
            view.insertSubview(contentView, at: 0)
        }
        if config.enableShadow {
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
                make.width.greaterThanOrEqualTo(config.cardMinWidth).priority(.low)
                make.width.lessThanOrEqualTo(config.cardMaxWidthByDefault)
                make.height.greaterThanOrEqualTo(config.cardMinHeight).priority(.low)
                make.height.lessThanOrEqualTo(config.cardMaxHeightByDefault)
            }
        }
        if contentStack.superview == nil {
            contentView.addSubview(contentStack)
            contentStack.spacing = config.margin + config.padding
            contentStack.snp.remakeConstraints { make in
                make.edges.equalTo(contentView).inset(config.padding)
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
        guard isViewDisplayed == false && config.actionAxis == nil else { return }
        let count = actionStack.arrangedSubviews.count
        guard count < 4 else { return }
        if isPortrait && count < 3 || !isPortrait {
            actionStack.axis = .horizontal
            actionStack.distribution = .fillEqually
        }
    }
    
    func updateTimeoutDuration() {
        // 设置持续时间
        vm.timeoutHandler = DispatchWorkItem(block: { [weak self] in
            self?.pop()
        })
    }
    
}

extension Alert {
    
    func setupImageView() {
        guard let icon = vm.icon else { return }
        imageView.image = icon
        contentStack.insertArrangedSubview(imageView, at: 0)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.remakeConstraints { (mk) in
            mk.top.left.greaterThanOrEqualTo(contentView).inset(config.padding*2.25)
            mk.right.bottom.lessThanOrEqualTo(contentView).inset(config.padding*2.25)
            mk.width.equalTo(config.iconSize.width)
            mk.height.equalTo(config.iconSize.height)
        }
        // 移除动画
        stopRotate(animateLayer)
        animateLayer = nil
        animation = nil
        
        // 移除进度
        progressView?.removeFromSuperview()
    }
    func setupTextStack() {
        let titleCount = vm.title?.count ?? 0
        let bodyCount = vm.message?.count ?? 0
        if titleCount > 0 || bodyCount > 0 {
            if textStack.superview != contentStack {
                if let index = contentStack.arrangedSubviews.firstIndex(of: imageView) {
                    contentStack.insertArrangedSubview(textStack, at: index + 1)
                } else {
                    contentStack.insertArrangedSubview(textStack, at: 0)
                }
                textStack.snp.remakeConstraints { (mk) in
                    mk.top.greaterThanOrEqualTo(contentView).inset(config.padding*1.75)
                    mk.bottom.lessThanOrEqualTo(contentView).inset(config.padding*1.75)
                    if UIScreen.main.bounds.width < 414 {
                        mk.left.greaterThanOrEqualTo(contentView).inset(config.padding*1.5)
                        mk.right.lessThanOrEqualTo(contentView).inset(config.padding*1.5)
                    } else {
                        mk.left.greaterThanOrEqualTo(contentView).inset(config.padding*2)
                        mk.right.lessThanOrEqualTo(contentView).inset(config.padding*2)
                    }
                }
            }
            if titleCount > 0 {
                titleLabel.text = vm.title
                if titleLabel.superview != textStack {
                    textStack.insertArrangedSubview(titleLabel, at: 0)
                }
                if bodyCount > 0 {
                    // 有message
                    titleLabel.font = config.titleFontByDefault
                } else {
                    // 没有message
                    titleLabel.font = config.boldTextFontByDefault
                }
            } else {
                if textStack.arrangedSubviews.contains(titleLabel) {
                    textStack.removeArrangedSubview(titleLabel)
                }
                titleLabel.removeFromSuperview()
            }
            if bodyCount > 0 {
                bodyLabel.text = vm.message
                if bodyLabel.superview != textStack {
                    textStack.addArrangedSubview(bodyLabel)
                }
                if titleCount > 0 {
                    // 有title
                    bodyLabel.font = config.bodyFontByDefault
                } else {
                    // 没有title
                    bodyLabel.font = config.boldTextFontByDefault
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
            if let axis = config.actionAxis {
                actionStack.axis = axis
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
        if config.enableShadow {
            contentView.layer.shadowPath = UIBezierPath.init(rect: contentView.bounds).cgPath
        }
    }
    
}