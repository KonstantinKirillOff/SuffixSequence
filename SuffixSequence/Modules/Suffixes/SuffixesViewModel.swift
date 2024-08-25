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
    @Published var results: [Result] = []
    @Published var summaryText = ""
    
    let jobScheduler: JobScheduler
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
        
        Task {
            await jobScheduler.$summaryText
                .receive(on: DispatchQueue.main)
                .assign(to: \.summaryText, on: self)
                .store(in: &cancellables)
        }
    }
    
    func startTimer() async {
        await jobScheduler.startSummaryTimer()
    }
    
    private func addSearchJobToQueue(_ word: String) {
        if let _ = results.firstIndex(where: { $0.queryText == word } ) {
            return
        }
            
        let job = Job(id: UUID(), word: word) { [weak self] result in
            DispatchQueue.main.async {
                self?.results.append(result)
                self?.results.sort { $0.totalWorkTimeMs < $1.totalWorkTimeMs }
                self?.updateColors()
            }
        }
        
        Task {
            await jobScheduler.addJob(job)
        }
    }
    
    private func updateColors() {
        guard let bestTimeResultId = results.first?.id else { return }
        guard let worstTimeResultId = results.last?.id else { return }
        
        for i in (0..<results.count) {
            if results[i].id == bestTimeResultId {
                results[i].color = .green
            } else if results[i].id == worstTimeResultId {
                results[i].color = .red
            } else {
                results[i].color = .black
            }
        }
    }

    private func getSuffixesFor(text string: String) {
        Task {
            await jobScheduler.clearHistory()            
        }
        results.removeAll()
        
        let words = string.components(separatedBy: " ")
        words.forEach { word in
            addSearchJobToQueue(word)
        }
    }
}
