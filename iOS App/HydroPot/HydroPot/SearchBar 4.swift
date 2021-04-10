//
//  SearchBar.swift
//  HydroPot
//
//  Created by David Dray on 4/6/21.
//

import SwiftUI

struct SearchBar: View {
    @State private var searchInput: String = "" //user's search input
    
    @Binding var searching: Bool    //boolean for if user is searching or not
    @Binding var mainList: [String] //the main list that is not altered
    @Binding var searchedList: [String] //the subset of the main list that is altered according to searches
    @Binding var displayedList: [String]    //the displayed list (altered from filter and search)
    @State var viewFilter: Bool = false     //variable for showing/hiding filter page
    @Binding var filteredValues: [(Bool,Bool,Bool)] //tuples for storing filtered values
    @Binding var urlList: [String]      //list of image urls
    var plants : Plants
    
    var body: some View {
        ZStack {
            HStack {
                HStack {
                    
                    // Search Area TextField
                    TextField("Search ...", text: $searchInput)
                        .onChange(of: searchInput, perform: { searchText in
                            if(searchInput != "") {
                                searching = true
                            } else {
                                searching = false
                            }
                            searchedList = mainList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.contains(searchText) }
                            self.urlList = updateImages(displayedList: displayedList, plants: plants)
                            
                            filterList(filteredValues: self.filteredValues, displayedList: &self.displayedList, plants: self.plants, searchedList: self.searchedList, urlList: &self.urlList)
                        })
                        .font(.system(size: UIScreen.regTextSize))
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    
                }
                //include the magnifying glass and the clear button on the search
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 14)
                        
                        if searching {
                            Button(action: {
                                self.searchInput = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 14)
                            }
                        }
                    }
                )
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))

                //include filter button in the search bar region
                Button(action: {
                    self.viewFilter.toggle()
                })
                {
                    Text("Filter")
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                        .cornerRadius(6)
                    
                }.sheet(isPresented: $viewFilter) {
                    //when pressed, go to the filter page
                    plantTypesFilter(showFilter: $viewFilter, filteredValues: $filteredValues)
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .frame(height: 50)
        }
    }
}
