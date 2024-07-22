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
        var offset = initialString.endIndex
        
        return AnyIterator {
            guard offset > initialString.startIndex else { return nil }
            offset = initialString.index(before: offset)
            return initialString[offset...]
        }
    }
}
