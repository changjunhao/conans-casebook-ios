//
//  CaseBook.swift
//  conan
//
//  Created by iFable on 2020/5/22.
//  Copyright © 2020 iFable. All rights reserved.
//

import Foundation

struct CaseBook {
    var id: Int
    var title: String
    var url: String
    var urlh: String
    var logo: String
    var year: Int
    var waiting: Bool
}

let caseTitles = [
    "计时引爆摩天楼",
    "第十四个目标",
    "世纪末的魔术师",
    "瞳孔中的暗杀者",
    "通往天国的倒计时",
    "贝克街的亡灵",
    "迷宫的十字路口",
    "银翼的魔术师",
    "水平线上的阴谋",
    "侦探们的镇魂曲",
    "蔚蓝的灵柩",
    "战栗的乐谱",
    "漆黑的追踪者",
    "天空的遇难船",
    "沉默的 15 分钟",
    "第 11 名王牌",
    "绝海的侦探",
    "异次元的狙击手",
    "业火的向日葵",
    "纯黑的噩梦",
    "枫红的恋歌",
]

extension CaseBook {
    static func create(index i: Int) -> CaseBook {
        return CaseBook(id: i + 1, title: caseTitles[i], url: "https://oss-materials.ifable.cn/conan/m\(i + 1).jpg?imageView2/0/interlace/1", urlh: "https://oss-materials.ifable.cn/conan/m\(i == 20 ? 1 : i + 1)h.jpg?imageView2/0/interlace/1", logo: "https://oss-materials.ifable.cn/conan/m\(i + 1)logo.png", year: 1997 + i, waiting: 1997 + i > 2009)
    }
}
