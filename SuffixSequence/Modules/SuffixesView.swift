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
            TextField("Enter your word here", text: $viewModel.wordsString)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                .frame(height: 30)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                }
            Picker("Options", selection: $selectedSegment) {
                ForEach(SegmentOptions.allCases, id: \.self) { option in
                    Text(option.rawValue)
                        .tag(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if selectedSegment == SegmentOptions.allSuffixes.rawValue {
                VStack {
                    Toggle(isOn: $viewModel.isASCSorting, label: {
                        Text("ASC/DESC")
                    })
                    List {
                        ForEach(viewModel.sortedArrayByName, id: \.self) { stringSuffix in
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


