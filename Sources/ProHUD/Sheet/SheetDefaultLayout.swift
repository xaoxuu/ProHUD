//
//  SheetDefaultLayout.swift
//  
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit

extension Sheet: DefaultLayout {
    
    var cfg: ProHUD.Configuration {
        return config
    }
    
    func reloadData(animated: Bool) {
        if self.cfg.customReloadData?(self) == true {
            return
        }
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
        var width = AppContext.appBounds.width - config.screenEdgeInset * 2
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
                        make.bottom.equalToSuperview().inset(config.screenEdgeInset)
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
            contentStack.snp.remakeConstraints { make in
                let safeArea: UIEdgeInsets
                if config.isFullScreen {
                    safeArea = AppContext.safeAreaInsets
                } else {
                    safeArea = .zero
                }
                make.top.equalToSuperview().offset(safeArea.top + config.cardEdgeInsets.top)
                make.bottom.equalToSuperview().inset(safeArea.bottom + config.cardEdgeInsets.bottom)
                if isPortrait {
                    make.left.equalToSuperview().inset(safeArea.left + config.cardEdgeInsets.left)
                    make.right.equalToSuperview().inset(safeArea.right + config.cardEdgeInsets.right)
                } else {
                    make.left.equalToSuperview().inset(safeArea.left + config.cardEdgeInsets.left * 2)
                    make.right.equalToSuperview().inset(safeArea.right + config.cardEdgeInsets.right * 2)
                }
            }
        }
        
    }
    
}
