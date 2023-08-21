//
//  Target.swift
//  
//
//  Created by xaoxuu on 2023/8/18.
//

import UIKit

@objc public protocol HUDControllerType {
    @objc func push()
    @objc func pop()
}

public protocol HUDTargetType: HUDControllerType {
    associatedtype ViewModel = HUDViewModelType
    var identifier: String { get set }
    var vm: ViewModel? { get set }
    init()
}
