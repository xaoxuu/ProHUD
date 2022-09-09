//
//  ListModel.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit

struct Row {
    var title: String
    var action: () -> Void
}

struct Section {
    var title: String
    var rows = [Row]()
    mutating func add(title: String, action: @escaping () -> Void) {
        rows.append(.init(title: title, action: action))
    }
}

struct ListModel {

    var sections = [Section]()
    
    mutating func add(title: String, rows: (_ section: inout Section) -> Void) {
        var sec = Section(title: title)
        rows(&sec)
        sections.append(sec)
    }
    
}
