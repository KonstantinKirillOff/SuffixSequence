//
//  Result.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import SwiftUI

struct Result: Identifiable {
    let id = UUID()
    let queryText: String
    let result: String
    let totalWorkTimeMs: TimeInterval
    let searchDate: String
    var color: Color = .black
}
