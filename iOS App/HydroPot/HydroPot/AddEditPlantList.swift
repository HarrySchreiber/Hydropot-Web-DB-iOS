
//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddEditPlantList: View {
    @Environment(\.presentationMode) var presentationMode
    @State var plants = Plants()
    @Binding var plantSelected: String
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
                            Button(action: {
                                plantSelected = searching ? searchedPlantList[row] : plantList[row]
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                ListCell(text: searching ? searchedPlantList[row] : plantList[row])
                                    .frame(height: 45)
                            }
                                .simultaneousGesture(TapGesture().onEnded {
                                    // Hide Keyboard after pressing a Cell
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                })
                        }
                    }
                }
            }.navigationBarHidden(true)
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
        return Plant()
    }
    
}

