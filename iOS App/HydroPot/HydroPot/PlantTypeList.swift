//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantTypeList: View {
    @State var plants : Plants
    @State private var searchQuery: String = ""
    
    @State private var plantList = [String]()
    @State private var searchedPlantList = [String]()
    @State private var searching = false
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // SearchBar
                SearchBar(searching: $searching, mainList: $plantList, searchedList: $searchedPlantList)
                
                // List
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(searching ? (0..<searchedPlantList.count) : (0..<plantList.count), id: \.self) { row in
                            NavigationLink(
                                destination:
                                    PlantTypePage(plant: getSelectedPlant(selectedPlant: (searching ? searchedPlantList[row] : plantList[row]))),
                                
                                label: {
                                    ListCell(text: searching ? searchedPlantList[row] : plantList[row])
                                        .frame(height: 45)
                                    
                                })
                                .simultaneousGesture(TapGesture().onEnded {
                                    // Hide Keyboard after pressing a Cell
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                })
                        }
                    }
                }
            }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Plant Types") // Navigation Bar Title
        }
        .onAppear(perform: {
            listOfPlants()
        })
    }
    
    func listOfPlants() {
        plantList = []
        for plant in plants.plantList {
            plantList.append(plant.plantType)
        }
    }
    func getSelectedPlant(selectedPlant: String) -> Plant {
        for plant in plants.plantList {
            if(plant.plantType == selectedPlant) {
                return plant
            }
        }
        print("error occured\n_____------_____----_____")
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up") 
    }
    
}

struct ListCell: View {
    var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack {
                HStack {
                    Image(systemName: "photo")
                        .padding(.leading, 15)
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                    Text(text)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Spacer()
            Divider()
        }
    }
}
struct SearchBar: View {
    @State private var searchInput: String = ""
    
    @Binding var searching: Bool
    @Binding var mainList: [String]
    @Binding var searchedList: [String]
    
    var body: some View {
        ZStack {
            HStack {
                // Search Bar
                HStack {
                    // Magnifying Glass Icon
                    Image(systemName: "magnifyingglass")
                    
                    // Search Area TextField
                    TextField("", text: $searchInput)
                        .onChange(of: searchInput, perform: { searchText in
                            searching = true
                            searchedList = mainList.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.contains(searchText) }
                            
                        })
                        .accentColor(.black)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                
                // 'Cancel' Button
                Button(action: {
                    searching = false
                    searchInput = ""
                    // Hide Keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text("Cancel")
                })
                .accentColor(Color.black)
                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 8))
            }
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        }
        .frame(height: 50)
    }
}

//struct PlantTypeList_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantTypeList(plants: Plants())
//    }
//}
