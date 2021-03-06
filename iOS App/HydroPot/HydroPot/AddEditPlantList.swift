
//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddEditPlantList: View {
    @Environment(\.presentationMode) var presentationMode
    @State var plants: Plants
    @Binding var plantSelected: String
    @Binding var idealTemperatureHigh: String
    @Binding var idealMoistureHigh: String
    @Binding var idealLightLevelHigh: String
    @Binding var idealTemperatureLow: String
    @Binding var idealMoistureLow: String
    @Binding var idealLightLevelLow: String
    
    @State private var searchQuery: String = ""
    @State private var plantList = [String]()
    @State private var searchedPlantList = [String]()
    @State private var displayedList = [String]()
    @State private var searching = false
    @State private var filtering = false
    //array of boolean tuples for low, medium and high moisture, light and temperature
    //(moisture low, medium high), then (light l, m, h), then (temperature l,m,h)
    @State var filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
    @State var urlList : [String] = []
    @State var fullUrlList : [String] = []
    
    var body: some View {
        let filterBinding = Binding<[(Bool,Bool,Bool)]>(
            get: {
            self.filteredValues
        }, set: {
            self.filteredValues = $0
            for val in self.filteredValues {
                filtering = false
                if(val.0 || val.1 || val.2) {
                    filtering = true
                    break
                }
            }
            filterList(filteredValues: self.filteredValues, displayedList: &self.displayedList, plants: self.plants, searchedList: (searching ? self.searchedPlantList : plantList), urlList: &self.urlList)
        })
        let bindDisplayList = Binding<[String]>(
            get:{(searching || filtering) ? self.displayedList : plantList
            },
            set:{self.displayedList = $0}
        )
        let bindUrlList = Binding<[String]>(
            get:{(searching || filtering) ? self.urlList : fullUrlList},
            set:{self.urlList = $0}
        )
        
        NavigationView {
            VStack(spacing: 0) {
                // SearchBar
                SearchBar(searching: $searching, mainList: $plantList, searchedList: $searchedPlantList, displayedList: $displayedList, filteredValues: filterBinding, urlList: bindUrlList, plants: plants)
                
                // List
                ScrollView {
                    VStack(spacing: 0) {
                        if((searching || filtering) && displayedList.count == 0) {
                            Text("No plant types match your query. \nTry filtering for something else!")
                                .bold()
                                .italic()
                                .padding()
                                .foregroundColor(.gray)
                                .navigationBarTitle("Notifications", displayMode: .inline)
                        }else {
                            ForEach((searching || filtering) ? (0..<displayedList.count) : (0..<plantList.count), id: \.self) { row in
                                Button(action: {
                                    plantSelected = (filtering || searching) ? displayedList[row] : plantList[row]
                                    
                                    if (plants.contains(plantName: plantSelected)){
                                        let tempPlant = plants.getPlant(plantName: plantSelected)
                                        idealMoistureHigh = String(tempPlant.idealMoistureHigh)
                                        idealMoistureLow = String(tempPlant.idealMoistureLow)
                                        idealTemperatureHigh = String(tempPlant.idealTempHigh)
                                        idealTemperatureLow = String(tempPlant.idealTempLow)
                                        idealLightLevelLow = String(tempPlant.idealLightLow)
                                        idealLightLevelHigh = String(tempPlant.idealLightHigh)
                                    }
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    ListCell(text: bindDisplayList[row], url: bindUrlList[row])
                                        .frame(height: UIScreen.plantTypeListImageSize)
                                        .padding(.top)
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    // Hide Keyboard after pressing a Cell
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                })
                            }
                        }
                    }
                }
            }.navigationBarHidden(true)
        }
        .onAppear(perform: {
            listOfPlants()
            self.fullUrlList = listOfImages(plantList: plants.plantList)
        })
    }
    
    func listOfPlants() {
        plantList = []
        for plant in plants.plantList {
            plantList.append(plant.plantType)
        }
    }
    func listOfImages(plantList: [Plant]) -> [String] {
        var urlList: [String] = []
        for plant in plantList {
            urlList.append(plant.imageURL)
        }
        print(urlList)
        return urlList
    }
    func getSelectedPlant(selectedPlant: String) -> Plant {
        for plant in plants.plantList {
            if(plant.plantType == selectedPlant) {
                return plant
            }
        }
        print("error occured\n_____------_____----_____")
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up", imageURL: "")
    }
}
