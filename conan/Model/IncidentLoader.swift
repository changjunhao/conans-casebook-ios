//
//  IncidentLoader.swift
//  conan
//
//  Created by iFable on 2020/6/11.
//  Copyright © 2020 iFable. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol IncidentLoaderDelegate {
    func successLoader(incident: Incident)
    func failureLoader(failure : Error)
}

class IncidentLoader {
    
    var delegate: IncidentLoaderDelegate?
    
    func loadListData(id: Int) {
        let parameters = ["id": id]
        AF.request("https://conan.ifable.cn/api/getIncident", parameters: parameters)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let data = response.value {
                        self.delegate?.successLoader(incident: Incident(jsonData: JSON(data)))
                    }
                case let .failure(error):
                    self.delegate?.failureLoader(failure: error)
                }
        }
    }
}
