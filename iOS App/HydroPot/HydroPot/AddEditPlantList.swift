
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
    @State private var searching = false
    //array of boolean tuples for low, medium and high moisture, light and temperature
    //(moisture low, medium high), then (light l, m, h), then (temperature l,m,h)
    @State var filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
    @State var urlList : [String] = []
    @State var fullUrlList : [String] = []
    
    var body: some View {
        let filterBinding = Binding<[(Bool,Bool,Bool)]>(get: {
            self.filteredValues
        }, set: {
            self.filteredValues = $0
            filterList(filteredValues: self.filteredValues)
        })
        let bindStringList = Binding<[String]>(
            get:{searching ? self.searchedPlantList : plantList},
            set:{self.urlList = $0}
        )
        let bindUrlList = Binding<[String]>(
            get:{searching ? self.urlList : fullUrlList},
            set:{self.urlList = $0}
        )
        
        NavigationView {
            VStack(spacing: 0) {
                // SearchBar
                //SearchBar(searching: $searching, mainList: $plantList, searchedList: $searchedPlantList, filteredValues: filterBinding, urlList: $urlList, plants: plants)
                
                // List
                ScrollView {
                    VStack(spacing: 0) {
                        if(plantList.count == 0) {
                            Text("No plant types match your filter(s). \nTry filtering for something else!")
                                .bold()
                                .italic()
                                .padding()
                                .foregroundColor(.gray)
                                .navigationBarTitle("Notifications", displayMode: .inline)
                        }else {
                            ForEach(searching ? (0..<searchedPlantList.count) : (0..<plantList.count), id: \.self) { row in
                                Button(action: {
                                    plantSelected = searching ? searchedPlantList[row] : plantList[row]
                                    
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
                                    ListCell(text: bindStringList[row], url: bindUrlList[row])
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
            self.urlList = listOfImages(plantList: plants.plantList)
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
    
    func filterList(filteredValues: [(Bool,Bool,Bool)]) {
        plantList = []
        //moisture values
        let moistureTuple = (20,35)
        //light values
        let lightTuple = (2500,10000)
        //temperature values
        let tempTuple = (55,70)
        let mNotSelected = !filteredValues[0].0 && !filteredValues[0].1 && !filteredValues[0].2
        let lNotSelected = !filteredValues[1].0 && !filteredValues[1].1 && !filteredValues[1].2
        let tNotSelected = !filteredValues[2].0 && !filteredValues[2].1 && !filteredValues[2].2
        
        for plant in plants.plantList {
            //true if plant is in the selected range(s)
            let lowMoisture = (filteredValues[0].0 && plant.idealMoistureHigh <= moistureTuple.0)
            let medMoisture = (filteredValues[0].1 && (plant.idealMoistureHigh <= moistureTuple.1 && plant.idealMoistureHigh > moistureTuple.0))
            let highMoisture = (filteredValues[0].2 && plant.idealMoistureHigh > moistureTuple.1)
            
            let lowLight = (filteredValues[1].0 && plant.idealLightHigh <= lightTuple.0)
            let medLight = (filteredValues[1].1 && (plant.idealLightHigh <= lightTuple.1 && plant.idealLightHigh > lightTuple.0))
            let highLight = (filteredValues[1].2 && plant.idealLightHigh > lightTuple.1)
            
            
            let lowTemp = (filteredValues[2].0 && plant.idealTempHigh <= tempTuple.0)
            let medTemp = (filteredValues[2].1 && (plant.idealTempHigh <= tempTuple.1 && plant.idealTempHigh > tempTuple.0))
            let highTemp = (filteredValues[2].2 && plant.idealTempHigh > tempTuple.1)
            
            
            let inMoistureRange = mNotSelected || lowMoisture || medMoisture || highMoisture
            let inLightRange = lNotSelected || lowLight || medLight || highLight
            let inTempRange = tNotSelected || lowTemp || medTemp || highTemp
            //if the plant matches the moisture filter section
            if(inMoistureRange && inLightRange && inTempRange) {
                //add plant to temp list
                plantList.append(plant.plantType)
            }
        }
    }
    
}
