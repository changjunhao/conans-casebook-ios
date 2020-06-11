//
//  IncidentLoader.swift
//  conan
//
//  Created by iFable on 2020/6/11.
//  Copyright © 2020 iFable. All rights reserved.
//

import Alamofire
import SwiftyJSON

class IncidentLoader {
    func loadListData(id: Int, finishBlock: @escaping (_ succcess: Bool, _ result: Incident?) -> Void) {
        let parameters = ["id": id]
        AF.request("https://conan.ifable.cn/api/getIncident", parameters: parameters)
            .validate()
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let data = response.value {
                        finishBlock(true, Incident(jsonData: JSON(data)))
                    } else {
                        finishBlock(false, nil)
                    }
                case .failure(_):
                    finishBlock(false, nil)
                }
        }
    }
}
