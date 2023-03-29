//
//  Model.swift
//  Dynamic-Tab-indicators-Animations
//
//  Created by shrise31 on 2023/3/28.
//

import SwiftUI

struct Tab: Identifiable, Hashable {
    
    var id: UUID = .init()
    var pageName: String
    var index: Int64
    var width: CGFloat = 0
    var minX: CGFloat = 0
}


var tabs_: [Tab] = [
    .init(pageName: "快讯", index: 1),
    .init(pageName: "实时解盘", index: 2),
    .init(pageName: "每日股评", index: 3),
    .init(pageName: "7×24", index: 4),
    .init(pageName: "国内焦点", index: 5),
    .init(pageName: "国际最新", index: 6),
    .init(pageName: "财经焦点", index: 7),
    .init(pageName: "财经", index: 8),
    .init(pageName: "社会", index: 9),
]

