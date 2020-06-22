//
//  Incident.swift
//  conan
//
//  Created by iFable on 2020/6/11.
//  Copyright © 2020 iFable. All rights reserved.
//

import Foundation
import SwiftyJSON

struct IncidentSectionItem {
    var title: String
    var desc: String
    var image: String
    
    init(jsonData: JSON) {
        title = jsonData["title"].stringValue
        desc = jsonData["desc"].stringValue
        image = jsonData["image"].stringValue
    }
    
    init(title: String, desc: String, image: String) {
        self.title = title
        self.desc = desc
        self.image = image
    }
}

class Incident {
    var title: String
    var section: [IncidentSectionItem]
    
    init(jsonData: JSON) {
        title = jsonData["title"].stringValue
        section = [IncidentSectionItem]()
        for i in 0..<jsonData["section"].count {
            section.append(IncidentSectionItem(jsonData: jsonData["section"][i]))
        }
    }
}
