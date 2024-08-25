//
//  ContentView.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 21.07.2024.
//

import Combine
import SwiftUI

struct SuffixesView: View {
    @StateObject var viewModel: SuffixesViewModel
    
    var body: some View {
        VStack{
            CustomTextFieldView(text: $viewModel.wordsString)
            Text("\(viewModel.summaryText)")
                .frame(maxWidth: .infinity, alignment: .leading)
            List {
                ForEach(viewModel.results, id: \.id) { result in
                    if !result.queryText.isEmpty {
                        VStack {
                            HStack {
                                Text(result.queryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(result.searchDate)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            HStack {
                                Text(result.result)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(format: "%.6f сек", result.totalWorkTimeMs))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .foregroundColor(result.color)
                    }
                }
                .listRowSeparator(.visible)
            }
            .listStyle(.plain)
            .task {
                await viewModel.startTimer()
            }
        }
        .padding()
    }
}

#Preview {
    SuffixesView(
        viewModel: SuffixesViewModel(jobScheduler: JobScheduler())
    )
}


