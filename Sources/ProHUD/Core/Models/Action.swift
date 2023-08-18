//
//  Action.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

open class Action: NSObject {
    
    /// 筛选过滤
    public struct Filter {
        public static var all: Filter { .init() }
        var ids = [String]()
        init(identifiers: [String] = []) {
            self.ids = identifiers
        }
        public static func identifiers(_ ids: String...) -> Filter {
            .init(identifiers: ids)
        }
    }
    
    /// 按钮样式
    public enum Style {
        case tinted // default, background with tintColor
        case gray // cancel button
        case destructive // red button, background with systemRed
        case filled(color: UIColor) // background with custom color
        case light(color: UIColor) // light background with custom color, text with custom color
        case plain(textColor: UIColor) // plain text
    }
    
    public private(set) var identifier: String?
    
    open var style: Style = .tinted
    
    open var title: String?
    
    open var handler: ((_ vc: HUDControllerType) -> Void)?

    public init(identifier: String? = nil, style: Style = .tinted, title: String?, handler: ((_ vc: HUDControllerType) -> Void)? = nil) {
        self.identifier = identifier
        self.style = style
        self.title = title
        self.handler = handler
    }
    
}

extension Action.Filter: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self.init(identifiers: [value])
    }
}
