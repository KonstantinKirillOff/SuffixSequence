//
//  JobScheduler.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 17.08.2024.
//

import Foundation

actor JobScheduler {
    @Published private (set) var summaryText: String = ""
    
    private let jobQueue = JobQueue()
    private (set) var searchHistory: [Result] = []
    private var isRunning = false
    private var summaryTimer: DispatchSourceTimer?
    
    func addJob(_ job: Job) {
        jobQueue.push(job)
        if !isRunning {
            Task {
                await runNextJob()
            }
        }
    }
    
    func startSummaryTimer() {
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: 20)
        timer.setEventHandler { [weak self] in
            Task { [weak self] in
                await self?.generateSummary()
            }
        }
        summaryTimer = timer
        timer.resume()
    }
    
    func clearHistory() {
        searchHistory.removeAll()
    }
   
    private func runNextJob() async {
        guard let job = jobQueue.pop() else {
            isRunning = false
            return
        }
        
        isRunning = true
        let startTime = Date()
        let suffixes = await findSuffixes(for: job.word)
        let endTame = Date()
        let totatTime = endTame.timeIntervalSince(startTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "RU_ru")
        dateFormatter.dateStyle = .short
        
        let result = Result(
            queryText: job.word,
            result: suffixes,
            totalWorkTimeMs: totatTime,
            searchDate: dateFormatter.string(from: startTime)
        )
        saveResult(result: result)
        job.completion(result)
        
        await runNextJob()
    }
    
    private func findSuffixes(for word: String) async -> String {
        return SuffixSequence(initialString: word).map { String($0) }.joined(separator: ", ")
    }
    
    private func saveResult(result: Result) {
        searchHistory.append(result)
    }
    
    private func generateSummary() async {
        if searchHistory.isEmpty {
            summaryText = "Среднее время поиска:"
            return
        }
        
        let averageTime = searchHistory.map { $0.totalWorkTimeMs }.reduce(0, +) / Double(searchHistory.count)
        summaryText = "Среднее время поиска: \(String(format: "%.6f сек", averageTime))"
    }
    
    deinit {
        summaryTimer?.cancel()
    }
}
