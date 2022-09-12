//
//  File.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit
import ProHUD

public extension ViewModel {
//    static var plain: ViewModel {
//        ViewModel()
//    }
//    static var note: ViewModel {
//        ViewModel(icon: UIImage(named: "prohud.note"))
//    }
    // MARK: note
    static var note: ViewModel {
        .init(icon: UIImage(named: "demo.note"))
    }
    static func note(_ seconds: TimeInterval) -> ViewModel {
        .init(icon: UIImage(named: "demo.note"), duration: seconds)
    }
    static var msg: ViewModel {
        ViewModel(icon: UIImage(named: "demo.message"))
    }
    static func msg(_ seconds: TimeInterval) -> ViewModel {
        ViewModel(icon: UIImage(named: "demo.message"), duration: seconds)
    }
    static var delete: ViewModel {
        ViewModel(icon: UIImage(named: "demo.trash"))
    }
    // MARK: confirm
    static var confirm: ViewModel {
        .init(icon: UIImage(named: "demo.questionmark"))
    }
    static func confirm(_ seconds: TimeInterval) -> ViewModel {
        .init(icon: UIImage(named: "demo.questionmark"), duration: seconds)
    }
    
//    static func loading(_ seconds: TimeInterval) -> ViewModel {
//        let obj = ViewModel(icon: UIImage(named: "prohud.rainbow.circle"), duration: seconds)
//        obj.rotation = .init(repeatCount: .infinity)
//        return obj
//    }
}
