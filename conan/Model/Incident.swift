//
//  Incident.swift
//  conan
//
//  Created by iFable on 2020/6/11.
//  Copyright © 2020 iFable. All rights reserved.
//

import Foundation

struct IncidentSectionItem: Codable {
    let title: String
    let desc: String
    let image: String
}

struct Incident: Codable {
    let title: String
    let section: [IncidentSectionItem]
}
