//
//  GuardConfig.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/31.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import SnapKit
import Inspire

public extension ProHUD.Configuration {
    struct Guard {
        // MARK: 卡片样式
        /// 最大宽度（用于优化横屏或者iPad显示）
        public var cardMaxWidth = CGFloat(460)
        /// 圆角半径（手机竖屏时为0）
        public var cardCornerRadius = CGFloat(16)
        
        /// 余量：元素与元素之间的距离
        public var margin = CGFloat(8)
        /// 填充：元素内部控件距离元素边界的距离
        public var padding = CGFloat(16)
        
        // MARK: 图标样式
        /// 颜色
        public var tintColor: UIColor?
        
        // MARK: 文本样式
        /// 标题字体
        public var titleFont = UIFont.boldSystemFont(ofSize: 22)
        /// 标题颜色
        public var titleColor = UIColorForPrimaryLabel
        
        /// 正文字体
        public var bodyFont = UIFont.systemFont(ofSize: 18)
        /// 正文颜色
        public var bodyColor = UIColorForSecondaryLabel
        
        // MARK: 按钮样式
        /// 按钮字体
        public var buttonFont = UIFont.boldSystemFont(ofSize: 18)
        /// 按钮最大宽度（用于优化横屏或者iPad显示）
//        public var buttonMaxWidth = CGFloat(460)
        /// 按钮圆角半径
        public var buttonCornerRadius = CGFloat(12)
        
        lazy var loadTitleLabel: (ProHUD.Guard, Guard) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "loadTitleLabel")
                if vc.titleLabel == nil {
                    vc.titleLabel = UILabel()
                    vc.titleLabel?.font = config.titleFont
                    vc.titleLabel?.textColor = config.titleColor
                    vc.titleLabel?.numberOfLines = 0
                    vc.titleLabel?.textAlignment = .justified
                }
            }
        }()
        
        lazy var loadBodyLabel: (ProHUD.Guard, Guard) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "loadBodyLabel")
                if vc.bodyLabel == nil {
                    vc.bodyLabel = UILabel()
                    vc.bodyLabel?.font = config.bodyFont
                    vc.bodyLabel?.textColor = config.bodyColor
                    vc.bodyLabel?.numberOfLines = 0
                    vc.titleLabel?.textAlignment = .justified
                }
            }
        }()
        
        /// 加载视图
        lazy var loadSubviews: (ProHUD.Guard, Guard) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "loadSubviews")
                // background
                vc.view.tintColor = config.tintColor
                vc.view.backgroundColor = UIColor(white: 0, alpha: 0)
                vc.view.addSubview(vc.contentView)
                var width = UIScreen.main.bounds.width
                if width > config.cardMaxWidth {
                    // 横屏或者iPad
                    width = config.cardMaxWidth
                    vc.contentView.layer.masksToBounds = true
                    vc.contentView.layer.cornerRadius = config.cardCornerRadius
                } else {
                    vc.contentView.layer.shadowRadius = 4
                    vc.contentView.layer.shadowOffset = .init(width: 0, height: 2)
                    vc.contentView.layer.shadowOpacity = 0.12
                }
                vc.contentView.snp.makeConstraints { (mk) in
                    mk.centerX.equalToSuperview()
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        if width == config.cardMaxWidth {
                            mk.bottom.equalToSuperview().offset(-Inspire.shared.screen.safeAreaInsets.bottom)
                        } else {
                            mk.bottom.equalToSuperview()
                        }
                    } else if UIDevice.current.userInterfaceIdiom == .pad {
                        mk.centerY.equalToSuperview()
                    }
                    mk.width.equalTo(width)
                }
                // stack
                vc.contentView.contentView.addSubview(vc.contentStack)
                vc.contentStack.snp.makeConstraints { (mk) in
                    mk.top.equalToSuperview().offset(config.padding + config.margin)
                    mk.centerX.equalToSuperview()
                    if width == config.cardMaxWidth {
                        mk.bottom.equalToSuperview().offset(-config.padding)
                    } else {
                        mk.bottom.equalToSuperview().offset(-config.margin-Inspire.shared.screen.safeAreaInsets.bottom)
                    }
                    if isPortrait {
                        mk.width.equalToSuperview().offset(-config.padding * 2)
                    } else {
                        mk.width.equalToSuperview().offset(-config.padding * 4)
                    }
                }
                vc.contentStack.addArrangedSubview(vc.textStack)
                
            }
        }()
        
        /// 更新视图
        lazy var updateFrame: (ProHUD.Guard, Guard) -> Void = {
            return { (vc, config) in
                debugPrint(vc, "updateFrame")
            }
        }()
        
        /// 加载视图
        /// - Parameter callback: 回调代码
        public mutating func loadSubviews(_ callback: @escaping (ProHUD.Guard, Guard) -> Void) {
            loadSubviews = callback
        }
        
        /// 更新视图
        /// - Parameter callback: 回调代码
        public mutating func updateFrame(_ callback: @escaping (ProHUD.Guard, Guard) -> Void) {
            updateFrame = callback
        }
        
    }
}

internal var guardConfig = ProHUD.Configuration.Guard()

public extension ProHUD {
    static func configGuard(_ config: (inout Configuration.Guard) -> Void) {
        config(&guardConfig)
    }
}
