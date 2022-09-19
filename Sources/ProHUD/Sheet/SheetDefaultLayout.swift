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
    
    func reloadDataByDefault() {
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
    
    func loadContentViewIfNeeded() {
        contentView.layer.cornerRadiusWithContinuous = config.cardCornerRadiusByDefault
        if contentView.superview != view {
            view.insertSubview(contentView, aboveSubview: backgroundView)
        }
        // mask
        loadContentMaskViewIfNeeded()
        // layout
        let maxWidth = config.cardMaxWidthByDefault
        var width = UIScreen.main.bounds.width - config.edgeInset * 2
        if width > maxWidth {
            // landscape iPhone or iPad
            width = maxWidth
        }
        contentView.snp.remakeConstraints { make in
            if config.isFullScreen {
                make.edges.equalToSuperview()
            } else {
                make.centerX.equalToSuperview()
                if UIDevice.current.userInterfaceIdiom == .phone {
                    if width < maxWidth {
                        make.bottom.equalToSuperview().inset(config.edgeInset)
                    } else {
                        make.bottom.equalToSuperview().inset(screenSafeAreaInsets.bottom)
                    }
                } else if UIDevice.current.userInterfaceIdiom == .pad {
                    make.centerY.equalToSuperview()
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
                if config.isFullScreen {
                    make.top.equalToSuperview().offset(screenSafeAreaInsets.top)
                } else {
                    make.top.equalToSuperview().offset(config.padding * 2)
                }
                make.bottom.equalToSuperview().inset(config.padding * 2)
                if isPortrait {
                    make.left.right.equalToSuperview().inset(config.padding)
                } else {
                    make.left.right.equalToSuperview().inset(config.padding * 2)
                }
            }
        }
        
    }
    
    
}
