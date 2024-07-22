//
//  SuffixesViewModel.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 22.07.2024.
//

import Combine

final class SuffixesViewModel: ObservableObject {
    @Published var wordsString = ""
    @Published var searchString = ""
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    private func setFilterForItems() {
        
    }
    
    private func getSuffixesForString() {
        
    }
}
