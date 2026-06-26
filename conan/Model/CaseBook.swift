//
//  CaseBook.swift
//  conan
//
//  Created by iFable on 2020/5/22.
//  Copyright © 2020 iFable. All rights reserved.
//

import Foundation

struct CaseBook {
    let id: Int
    let title: String
    let url: String
    let urlh: String
    let logo: String
    let year: Int
    let waiting: Bool
}

extension CaseBook {
    /// 所有电影标题，供 CaseBookService 使用
    static let caseTitles = [
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

    static func create(index i: Int) -> CaseBook {
        CaseBook(
            id: i + 1,
            title: caseTitles[i],
            url: APIConfiguration.movieImage(index: i + 1),
            urlh: APIConfiguration.movieImageHorizontal(index: i + 1),
            logo: APIConfiguration.movieLogo(index: i + 1),
            year: 1997 + i,
            waiting: 1997 + i > 2009
        )
    }
}
