//
//  SuffixesViewModel.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 22.07.2024.
//

import SwiftUI
import Combine

final class SuffixesViewModel: ObservableObject {
    @Published var wordsString = ""
    @Published var searchString = ""
    @Published var isASCSorting = true
    @Published var sortedArray: [String] = []
    
    private (set) var suffixesCountDict: [String : [String]] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $wordsString
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .map({ $0.lowercased() })
            .sink { [weak self] string in
                self?.getSuffixesFor(text: string)
            }
            .store(in: &cancellables)
        
        $isASCSorting
            .sink { [weak self] isASCSorting in 
                self?.setSorting(isASCSorting: isASCSorting)
            }
            .store(in: &cancellables)
    }
    
    private func setFilterForItems() {
        
    }
    
    private func getSuffixesFor(text string: String) {
        suffixesCountDict.removeAll()
        
        var suffixesArray = [String]()
        let words = string.components(separatedBy: " ")
        words.forEach { word in
            let wordSuffixes = SuffixSequence(initialString: word)
            for suffix in wordSuffixes {
                suffixesArray.append(String(suffix))
            }
        }
        suffixesCountDict = Dictionary(grouping: suffixesArray, by: { $0 })
        setSorting(isASCSorting: isASCSorting)
    }
    
    private func setSorting(isASCSorting: Bool) {
        sortedArray = Array(suffixesCountDict.keys.sorted(by: { left, right in
            if isASCSorting {
                return right > left
            } else {
                return left > right
            }
        }))
    }
}
