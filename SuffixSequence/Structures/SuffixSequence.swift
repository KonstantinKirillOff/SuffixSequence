//
//  SuffixIterator.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 21.07.2024.
//

import Foundation

struct SuffixSequence: Sequence {
    let initialString: String
    
    func makeIterator() -> AnyIterator<Substring> {
        var offset = initialString.startIndex
        
        return AnyIterator {
            guard offset < initialString.endIndex else { return nil }
            defer { offset = initialString.index(after: offset) }
            return initialString[offset...]
        }
    }
}


