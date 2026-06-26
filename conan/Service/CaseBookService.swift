//
//  CaseBookService.swift
//  conan
//
//  Created by iFable on 2025/6/26.
//  Copyright © 2025 iFable. All rights reserved.
//

import Foundation

protocol CaseBookProviding {
    func fetchCaseBooks() -> [CaseBook]
}

struct CaseBookService: CaseBookProviding {
    func fetchCaseBooks() -> [CaseBook] {
        (0..<CaseBook.caseTitles.count).map { CaseBook.create(index: $0) }
    }
}
