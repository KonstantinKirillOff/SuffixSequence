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
    @State var selectedSegment = "Все суфиксы"
    
    var body: some View {
        VStack{
            CustomTextFieldView(text: $viewModel.wordsString)
            Picker("Options", selection: $selectedSegment) {
                ForEach(SegmentOptions.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedSegment == SegmentOptions.allSuffixes.rawValue {
                VStack {
                    HStack {
                        CustomTextFieldView(text: $viewModel.searchString)
                        Button {
                            viewModel.addRequest()
                        } label: {
                            Text("search")
                        }
                    }
                    Toggle(isOn: $viewModel.isASCSorting, label: {
                        Text("ASC/DESC")
                    })
                    
                    let dataForList = viewModel.isFiltered ? viewModel.filteredArray : viewModel.sortedArrayByName
                    List {
                        ForEach(dataForList, id: \.self) { stringSuffix in
                            let title = "\(stringSuffix) - \(viewModel.suffixesCountDict[stringSuffix]?.count ?? 0 > 0 ? String(viewModel.suffixesCountDict[stringSuffix]?.count ?? 0) : "")"
                            Text(stringSuffix.count >= 3 ? title : stringSuffix)
                        }
                    }
                    .listStyle(.plain)
                }
            } else if selectedSegment == SegmentOptions.top10.rawValue {
                List {
                    ForEach(viewModel.sortedArrayByCount, id: \.self) { stringSuffix in
                        Text("\(stringSuffix) - \(viewModel.suffixesCountDict[stringSuffix]?.count ?? 0)")
                    }
                }
                .listStyle(.plain)
                .onAppear {
                    viewModel.setSortingByCount()
                }
                Spacer()
            } else {
                List {
                    ForEach(viewModel.results, id: \.id) { result in
                        Text("\(result.queryText) - \(result.totalWorkTimeMs) - \(result.queryDate)")
                            .background(getColor(id: result.id))
                    }
                }
                .listStyle(.plain)
                .task {
                    await viewModel.getResults()
                }
            }
        }
        .padding()
    }
    
    enum SegmentOptions: String, CaseIterable {
        case allSuffixes = "Все суфиксы"
        case top10 = "Топ 10"
        case history = "История"
    }
    
    func getColor(id: UUID) -> Color {
        if id == viewModel.bestResultId {
            return Color.green
        } else if id == viewModel.worstResultId {
            return Color.red
        } else {
            return Color.clear
        }
    }
}

#Preview {
    SuffixesView(
        viewModel: SuffixesViewModel(jobScheduler: JobScheduler())
    )
}


