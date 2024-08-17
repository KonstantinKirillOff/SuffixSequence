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
    @Published var sortedArrayByCount: [String] = []
    @Published var filteredArray: [String] = []
    @Published var results: [Result] = []
    @Published var isFiltered = false
    
    private (set) var sortedArrayByName: [String] = []
    private (set) var suffixesCountDict: [String : [String]] = [:]
    
    private (set) var bestResultId: UUID?
    private var bestResult: Double = Double.infinity
    
    private (set) var worstResultId: UUID?
    private var worstResult: Double = 0
    
    let jobScheduler: JobScheduler
    private var currentTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init(jobScheduler: JobScheduler) {
        self.jobScheduler = jobScheduler
        
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
        
        $searchString
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] string in
                self?.changeSearch()
            }
            .store(in: &cancellables)
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
    
   
    func addRequest() {
        //requestQueue.push(element: text)
        guard !searchString.isEmpty else { return }
        guard currentTask == nil else {
            print("is occupied")
            return
        }
        
        currentTask = Task {
            let startWork = Date()
            await setFilterForItems(text: searchString)
            let finishWork = Date()
            let total = startWork.distance(to: finishWork)
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "RU_ru")
            dateFormatter.dateStyle = .short
            
            let result = Result(
                queryText: searchString,
                totalWorkTimeMs: startWork.distance(to: finishWork),
                queryDate: dateFormatter.string(from: startWork)
            )
            
            if total < bestResult {
                bestResultId = result.id
                bestResult = total
            }
            
            if total > worstResult {
                worstResultId = result.id
                worstResult = total
            }
            
            await jobScheduler.saveResult(result: result)
            currentTask = nil
        }
    }
    
    @MainActor
    func getResults() async {
        results = await jobScheduler.results
    }
    
    private func setFilterForItems(text: String) async {
        if !text.isEmpty {
            filteredArray = sortedArrayByName.filter { $0.contains(text) }
            isFiltered = true
        } else {
            filteredArray = sortedArrayByName
            isFiltered = false
        }
    }
    
    private func changeSearch() {
        if searchString.isEmpty {
            isFiltered = false
        }
    }
    
    private func getSuffixesFor(text string: String) {
        isFiltered = false
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
}
