//
//  JobQueue.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import Foundation

final class JobQueue {
    var queue = [String]()
    
    func isEmpty() -> Bool {
        queue.isEmpty
    }
    
    func pop() -> String? {
        if queue.isEmpty {
            return nil
        }
        let job = queue.removeFirst()
        return job
    }
    
    func push(element: String) {
        queue.append(element)
    }
}
