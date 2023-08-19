//
//  SheetDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension SheetTarget: DefaultLayout {
    
    var cfg: CommonConfiguration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
        view.tintColor = vm?.tintColor ?? config.tintColor
        // background
        if backgroundView.superview == nil {
            view.insertSubview(backgroundView, at: 0)
            backgroundView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            config.customBackgroundViewMask?(backgroundView)
        }
        // content
        loadContentViewIfNeeded()
        
        if isViewDisplayed {
            UIView.animateEaseOut(duration: config.animateDurationForReloadByDefault) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func loadContentViewIfNeeded() {
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        if contentView.superview != view {
            view.insertSubview(contentView, aboveSubview: backgroundView)
        }
        // mask
        loadContentMaskViewIfNeeded()
        // layout
        let maxWidth = config.cardMaxWidthByDefault
        var width = AppContext.appBounds.width - config.windowEdgeInset * 2
        if width > maxWidth {
            // landscape iPhone or iPad
            width = maxWidth
        }
        contentView.snp.remakeConstraints { make in
            if config.isFullScreen {
                make.edges.equalToSuperview()
            } else {
                make.centerX.equalToSuperview()
                if UIDevice.current.userInterfaceIdiom == .pad && width >= maxWidth {
                    // iPad且窗口宽度较宽时居中弹出
                    make.centerY.equalToSuperview()
                } else {
                    if isPortrait {
                        make.bottom.equalToSuperview().inset(config.windowEdgeInset)
                    } else {
                        make.bottom.equalToSuperview().inset(AppContext.safeAreaInsets.bottom)
                    }
                }
                make.width.equalTo(width)
                make.height.greaterThanOrEqualTo(config.cardCornerRadiusByDefault * 2)
                make.height.lessThanOrEqualTo(config.cardMaxHeightByDefault)
            }
        }
        guard customView == nil else {
            if contentStack.superview != nil {
                contentStack.removeFromSuperview()
            }
            return
        }
        // stack
        if contentStack.superview == nil {
            contentView.addSubview(contentStack)
            let isFullScreen = config.isFullScreen
            let cardEdgeInsets = config.cardEdgeInsetsByDefault
            contentStack.snp.remakeConstraints { make in
                var safeAreaInsets = cardEdgeInsets
                if isFullScreen {
                    safeAreaInsets.top += AppContext.safeAreaInsets.top
                    safeAreaInsets.bottom += AppContext.safeAreaInsets.bottom
                }
                make.top.equalToSuperview().inset(safeAreaInsets.top)
                make.bottom.equalToSuperview().inset(safeAreaInsets.bottom)
                if isPortrait {
                    if isFullScreen {
                        safeAreaInsets.left += AppContext.safeAreaInsets.left
                        safeAreaInsets.right += AppContext.safeAreaInsets.right
                    }
                    make.left.equalToSuperview().inset(safeAreaInsets.left)
                    make.right.equalToSuperview().inset(safeAreaInsets.right)
                } else {
                    if isFullScreen {
                        safeAreaInsets.left += safeAreaInsets.left + AppContext.safeAreaInsets.left
                        safeAreaInsets.right += safeAreaInsets.right + AppContext.safeAreaInsets.right
                    }
                    make.left.equalToSuperview().inset(safeAreaInsets.left)
                    make.right.equalToSuperview().inset(safeAreaInsets.right)
                }
            }
        }
        
    }
    
}
