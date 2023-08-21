//
//  SheetProvider.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

public final class SheetProvider: HUDProviderType {
    
    public typealias ViewModel = SheetViewModel
    public typealias Target = SheetTarget
    
    /// 根据自定义的初始化代码创建一个Target并显示
    /// - Parameter initializer: 初始化代码（传空值时不会做任何事）
    @discardableResult public required init(initializer: ((_ target: Target) -> Void)?) {
        guard let initializer = initializer else {
            // Provider的作用就是push一个target
            // 如果没有任何初始化代码就没有target，就是个无意义的Provider
            // 但为了支持lazyPush（找到已有实例并更新），所以就需要支持无意义的Provider
            // 详见子类中的 self.init(initializer: nil)
            return
        }
        let t = Target()
        initializer(t)
        t.push()
    }
    
    /// 如果不存在就创建并弹出一个HUD实例，如果存在就更新实例
    /// - Parameters:
    ///   - identifier: 实例唯一标识符（如果为空，则以代码位置为唯一标识符）
    ///   - handler: 实例创建代码
    public static func lazyPush(identifier: String? = nil, file: String = #file, line: Int = #line, handler: @escaping (_ sheet: Target) -> Void, onExists: ((_ sheet: Target) -> Void)? = nil) {
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
    @discardableResult public static func find(identifier: String, update handler: ((_ sheet: Target) -> Void)? = nil) -> [Target] {
        let arr = AppContext.sheetWindows.values.flatMap({ $0 }).compactMap({ $0.sheet }).filter({ $0.identifier == identifier })
        if let handler = handler {
            arr.forEach({ $0.update(handler: handler) })
        }
        return arr
    }
    
}

public typealias Sheet = SheetProvider
