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
    static var msg: ViewModel {
        ViewModel(icon: UIImage(inProHUD: "prohud.message"))
    }
    static func msg(_ seconds: TimeInterval) -> ViewModel {
        ViewModel(icon: UIImage(inProHUD: "prohud.message"), duration: seconds)
    }
    static var loading: ViewModel {
        let obj = ViewModel(icon: UIImage(named: "prohud.rainbow.circle"))
        obj.rotation = .init(repeatCount: .infinity)
        return obj
    }
//    static func loading(_ seconds: TimeInterval) -> ViewModel {
//        let obj = ViewModel(icon: UIImage(named: "prohud.rainbow.circle"), duration: seconds)
//        obj.rotation = .init(repeatCount: .infinity)
//        return obj
//    }
}
