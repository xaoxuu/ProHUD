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
        
        view.tintColor = vm?.tintColor ?? config.tintColor
        
        // content
        loadContentViewIfNeeded()
        loadContentMaskViewIfNeeded()
        
        // text
        if contentStack.arrangedSubviews.contains(textLabel) == false {
            contentStack.addArrangedSubview(textLabel)
        }
        let text = [vm?.title ?? "", vm?.message ?? ""].filter({ $0.count > 0 }).joined(separator: " ")
        if text.count > 0 {
            textLabel.snp.remakeConstraints { make in
                make.width.lessThanOrEqualTo(AppContext.appBounds.width * 0.5)
            }
            textLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            textLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            textLabel.text = text
            textLabel.sizeToFit()
        }
        
        // 后设置image, 需要参考text
        setupImageView()
        
        view.layoutIfNeeded()
        
        if isViewAppeared {
            // 更新时间
            updateTimeoutDuration()
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.view.layoutIfNeeded()
            }
            updateWindowSize()
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
                make.centerY.equalToSuperview()
                if config.cardMinWidth != nil {
                    make.left.greaterThanOrEqualToSuperview().inset(config.cardEdgeInsetsByDefault.left)
                } else {
                    make.centerX.equalToSuperview()
                }
            }
        }
        
    }
    
    private func setupImageView() {
        
        if vm?.icon == nil && vm?.iconURL == nil {
            contentStack.removeArrangedSubview(imageView)
        } else {
            if contentStack.arrangedSubviews.contains(imageView) == false {
                contentStack.insertArrangedSubview(imageView, at: 0)
            }
            if config.iconSizeByDefault != .zero {
                imageView.snp.remakeConstraints { make in
                    make.height.equalTo(config.iconSizeByDefault)
                    make.width.equalTo(config.iconSizeByDefault)
                }
            }
        }
        imageView.image = vm?.icon
        if let iconURL = vm?.iconURL {
            config.customWebImage?(imageView, iconURL)
        }
        
        vm?.updateRotation()
        vm?.updateProgress()
        
    }
    
    func getWindowSize(window: CapsuleWindow) -> CGSize {
        let cardEdgeInsetsByDefault = config.cardEdgeInsetsByDefault
        view.layoutIfNeeded()
        let size = contentStack.frame.size
        let width = min(config.cardMaxWidthByDefault, size.width + cardEdgeInsetsByDefault.left + cardEdgeInsetsByDefault.right)
        let height = min(config.cardMaxHeightByDefault, size.height + cardEdgeInsetsByDefault.top + cardEdgeInsetsByDefault.bottom)
        return .init(width: max(width, config.cardMinWidth ?? 0), height: max(height, config.cardMinHeight))
    }
    
    func getWindowFrame(size: CGSize) -> CGRect {
        // 应用到frame
        let newFrame: CGRect
        switch vm?.position {
        case .top, .none:
            let topLayoutMargins = AppContext.appWindow?.safeAreaInsets.top ?? 8
            let y = max(topLayoutMargins, 8)
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: y, width: size.width, height: size.height)
        case .middle:
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: (AppContext.appBounds.height - size.height) / 2 - 20, width: size.width, height: size.height)
        case .bottom:
            let bottomLayoutMargins = AppContext.appWindow?.layoutMargins.bottom ?? 8
            let y = AppContext.appBounds.height - bottomLayoutMargins - size.height - 60
            newFrame = .init(x: (AppContext.appBounds.width - size.width) / 2, y: y, width: size.width, height: size.height)
        }
        return newFrame
    }
    
    func updateWindowSize() {
        guard let window = view.window as? CapsuleWindow else { return }
        window.isUserInteractionEnabled = tapActionCallback != nil
        let size = getWindowSize(window: window)
        let newFrame = getWindowFrame(size: size)
        window.transform = .identity
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            window.frame = newFrame
            window.layoutIfNeeded()
        }
        if vm?.position == .top {
            ToastWindow.updateToastWindowsLayout()
        }
    }
    
}
