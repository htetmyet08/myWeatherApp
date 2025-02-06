//
//  SpotlightSearchView.swift
//  WeatherApp
//
//  Created by htetmyet on 2/5/25.
//

import SwiftUI

struct SpotlightSearchView: View {
    @State private var isSearching = false
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isSearching = true
                            }
                        }
                    
                    if isSearching {
                        Button(action: {
                            withAnimation(.spring()) {
                                searchText = ""
                                isSearching = false
                                hideKeyboard()
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .shadow(radius: isSearching ? 5 : 0)
                .padding(.horizontal)
            }
            
            if isSearching {
                List(searchResults, id: \..self) { result in
                    Text(result)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut, value: isSearching)
            }
        }
        .padding(.top, isSearching ? 20 : 0)
    }
    
    private var searchResults: [String] {
        searchText.isEmpty ? [] : ["Result 1", "Result 2", "Result 3"]
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SpotlightSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightSearchView()
    }
}


