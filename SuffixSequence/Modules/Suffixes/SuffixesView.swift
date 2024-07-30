//
//  ContentView.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 21.07.2024.
//

import Combine
import SwiftUI

struct SuffixesView: View {
    @ObservedObject var viewModel = SuffixesViewModel()
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
                    CustomTextFieldView(text: $viewModel.searchString)
                    Toggle(isOn: $viewModel.isASCSorting, label: {
                        Text("ASC/DESC")
                    })
                    List {
                        ForEach(viewModel.filteredArray, id: \.self) { stringSuffix in
                            let title = "\(stringSuffix) - \(viewModel.suffixesCountDict[stringSuffix]?.count ?? 0 > 0 ? String(viewModel.suffixesCountDict[stringSuffix]?.count ?? 0) : "")"
                            Text(stringSuffix.count >= 3 ? title : stringSuffix)
                        }
                    }
                    .listStyle(.plain)
                }
            } else {
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
            }
        }
        .padding()
    }
    
    enum SegmentOptions: String, CaseIterable {
        case allSuffixes = "Все суфиксы"
        case top10 = "Топ 10 популярных"
    }
}

#Preview {
    SuffixesView()
}


