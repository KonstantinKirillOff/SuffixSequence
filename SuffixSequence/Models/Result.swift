//
//  Result.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import Foundation

struct Result: Identifiable {
    let id = UUID()
    let queryText: String
    let totalWorkTimeMs: Double
    let queryDate: String
}
