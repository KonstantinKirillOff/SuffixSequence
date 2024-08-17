//
//  JobScheduler.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import Foundation

actor JobScheduler {
    private (set) var results: [Result] = []
   
    
    func saveResult(result: Result) {
        results.append(result)
    }
}
