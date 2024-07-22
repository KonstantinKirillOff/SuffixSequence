//
//  ContentView.swift
//  HW_SuffixSequence
//
//  Created by Konstantin Kirillov on 21.07.2024.
//

import Combine
import SwiftUI

struct SuffixesView: View {
    @State var selectedSegment = "Все суфиксы"
    @State var wordString = ""
    
    var body: some View {
        VStack{
            TextField("Enter your word here", text: $wordString)
                .frame(width: .infinity, height: 30)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
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
            Spacer()
            
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


