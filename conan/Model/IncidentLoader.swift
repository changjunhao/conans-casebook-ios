//
//  IncidentLoader.swift
//  conan
//
//  Created by iFable on 2020/6/11.
//  Copyright © 2020 iFable. All rights reserved.
//

import Foundation

struct IncidentLoader {
    func loadIncident(id: Int) async throws -> Incident {
        guard let url = URL(string: APIConfiguration.incidentAPI(id: id)) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Incident.self, from: data)
    }
}
