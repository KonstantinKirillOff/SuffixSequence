//
//  Job.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 25.08.2024.
//

import Foundation

struct Job {
    let id: UUID
    let word: String
    let completion: (Result) -> Void
}
