//
//  IncidentService.swift
//  conan
//
//  Created by iFable on 2025/6/26.
//  Copyright © 2025 iFable. All rights reserved.
//

import Foundation

protocol IncidentProviding {
    func loadIncident(id: Int) async throws -> Incident
}

struct IncidentService: IncidentProviding {
    private let loader: IncidentLoader

    init(session: URLSession = .shared) {
        self.loader = IncidentLoader(session: session)
    }

    func loadIncident(id: Int) async throws -> Incident {
        try await loader.loadIncident(id: id)
    }
}
