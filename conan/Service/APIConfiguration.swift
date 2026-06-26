//
//  APIConfiguration.swift
//  conan
//
//  Created by iFable on 2025/6/26.
//  Copyright © 2025 iFable. All rights reserved.
//

import Foundation

enum APIConfiguration {
    static let baseURL = "https://oss-materials.ifable.cn/conan"
    static let apiBaseURL = "https://conan.ifable.cn/api"

    /// 电影封面图（竖版海报）
    static func movieImage(index: Int) -> String {
        "\(baseURL)/m\(index).jpg?imageView2/0/interlace/1"
    }

    /// 电影封面图（横版海报，翻转卡片时使用）
    static func movieImageHorizontal(index: Int) -> String {
        "\(baseURL)/m\(index == 20 ? 1 : index)h.jpg?imageView2/0/interlace/1"
    }

    /// 电影 Logo 图
    static func movieLogo(index: Int) -> String {
        "\(baseURL)/m\(index)logo.png"
    }

    /// 详情页背景图（模糊处理）
    static func movieBackground(id: Int) -> String {
        "\(baseURL)/m\(id)-bg.jpg"
    }

    /// 详情页音频文件
    static func movieAudio(id: Int) -> String {
        "\(baseURL)/m\(id).mp3"
    }

    /// 详情页顶部插图
    static func moviePicture(id: Int) -> String {
        "\(baseURL)/m\(id)-pic-2.png"
    }

    /// 案件详情 API
    static func incidentAPI(id: Int) -> String {
        "\(apiBaseURL)/getIncident?id=\(id)"
    }

    /// 静候上线 Logo
    static var waitingLogo: String {
        "\(baseURL)/mov-e.png"
    }

    /// 可查看详情 Logo
    static var availableLogo: String {
        "\(baseURL)/mov-d.png"
    }
}
