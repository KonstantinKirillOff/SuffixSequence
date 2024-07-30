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
    @Published var sortedArrayByName: [String] = []
    @Published var sortedArrayByCount: [String] = []
    
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
                self?.setSortingByName(isASCSorting: isASCSorting)
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
        setSortingByName(isASCSorting: isASCSorting)
    }
    
    private func setSortingByName(isASCSorting: Bool) {
        sortedArrayByName = Array(suffixesCountDict.keys.sorted(by: { left, right in
            if isASCSorting {
                return right > left
            } else {
                return left > right
            }
        }))
    }
    
    func setSortingByCount() {
        sortedArrayByCount = Array(suffixesCountDict.sorted { element1, element2 in
            if element1.value.count == element2.value.count {
                return element1.key < element2.key
            } else {
                return element1.value.count > element2.value.count
            }
        }.map { $0.key }.suffix(10))
    }
}
