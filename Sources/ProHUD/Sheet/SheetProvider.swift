//
//  SheetProvider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

open class SheetProvider: HUDProvider<SheetViewModel, SheetTarget> {
    
    public typealias ViewModel = SheetViewModel
    public typealias Target = SheetTarget
    
    @discardableResult @objc public required init(initializer: ((_ sheet: Target) -> Void)?) {
        super.init(initializer: initializer)
    }
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ sheet: SheetTarget) -> Void, onExists: ((_ sheet: SheetTarget) -> Void)? = nil) {
        let id = identifier ?? (file + "#\(line)")
        if let vc = find(identifier: id).last {
            vc.update(handler: onExists ?? handler)
        } else {
            Self.init { sheet in
                sheet.identifier = id
                handler(sheet)
            }
        }
    }
    
    /// 查找HUD实例
    /// - Parameter identifier: 唯一标识符
    /// - Returns: HUD实例
    @discardableResult public static func find(identifier: String, update handler: ((_ sheet: SheetTarget) -> Void)? = nil) -> [SheetTarget] {
        let arr = AppContext.sheetWindows.values.flatMap({ $0 }).compactMap({ $0.sheet }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

public typealias Sheet = SheetProvider
