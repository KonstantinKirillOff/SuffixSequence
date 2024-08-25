//
//  JobQueue.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import Foundation

final class JobQueue {
    private (set) var queue = [Job]()
    
    func isEmpty() -> Bool {
        queue.isEmpty
    }
    
    func pop() -> Job? {
        if queue.isEmpty {
            return nil
        }
        let job = queue.removeFirst()
        return job
    }
    
    func push(_ job: Job) {
        queue.append(job)
    }
}
