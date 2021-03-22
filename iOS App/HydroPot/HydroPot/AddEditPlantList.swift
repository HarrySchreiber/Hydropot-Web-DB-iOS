
//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddEditPlantList: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var ideals: Ideals; //ideals of the plants
    @State var plants: Plants   //list of plants
    
    @State private var searchQuery: String = "" //string searched by the user
    @State private var plantList = [String]()   //a string list of all the plants (for displaying)
    @State private var searchedPlantList = [String]()   //list of plants that match search criteria
    @State private var displayedList = [String]()       //list of plants that match search and filter - what is displayed
    @State private var searching = false        //boolean for if user is searching
    @State private var filtering = false        //boolean for if user is filtering
    
    //array of foolean tuples for low, medium and high moisture, light and temperature
    //(moisture low, medium high), then (light l, m, h), then (temperature l,m,h)
    @State var filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
    @State var urlList : [String] = []  //list of urls for images (what is displayed)
    @State var fullUrlList : [String] = []  //complete list of urls

    var body: some View {
        //binding variable for tracking filtered values (set in the filter page)
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
        //binding variable for the display list of plants (strings)
        let bindDisplayList = Binding<[String]>(
            get:{(searching || filtering) ? self.displayedList : plantList
            },
            set:{self.displayedList = $0}
        )
        //binding variable for the display list of plant images
        let bindUrlList = Binding<[String]>(
            get:{(searching || filtering) ? self.urlList : fullUrlList},
            set:{self.urlList = $0}
        )
        
        NavigationView {
            VStack(spacing: 0) {
                // SearchBar
                SearchBar(searching: $searching, mainList: $plantList, searchedList: $searchedPlantList, displayedList: $displayedList, filteredValues: filterBinding, urlList: bindUrlList, plants: plants)
                
                // List of plants and their images
                ScrollView {
                    VStack(spacing: 0) {
                        //inform user if no plants match their filter/search criteria
                        if((searching || filtering) && displayedList.count == 0) {
                            Text("No plant types match your query. \nTry filtering for something else!")
                                .font(.system(size: UIScreen.regTextSize))
                                .bold()
                                .italic()
                                .padding()
                                .foregroundColor(.gray)
                                .navigationBarTitle("Notifications", displayMode: .inline)
                        }
                        else {
                            //if the user is searching or filtering, loop through the trimmed down list of plants,
                            //otherwise show the complete list of plants
                            ForEach((searching || filtering) ? (0..<displayedList.count) : (0..<plantList.count), id: \.self) { row in
                                //if a plant is clicked, set the plant selected and store its ideals
                                Button(action: {
                                    ideals.plantSelected = (filtering || searching) ? displayedList[row] : plantList[row]
                                    if (plants.contains(plantName: ideals.plantSelected)){
                                        let tempPlant = plants.getPlant(plantName: ideals.plantSelected)
                                        ideals.idealMoistureHigh = String(tempPlant.idealMoistureHigh)
                                        ideals.idealMoistureLow = String(tempPlant.idealMoistureLow)
                                        ideals.idealTemperatureHigh = String(tempPlant.idealTempHigh)
                                        ideals.idealTemperatureLow = String(tempPlant.idealTempLow)
                                        ideals.idealLightLevelLow = String(tempPlant.idealLightLow)
                                        ideals.idealLightLevelHigh = String(tempPlant.idealLightHigh)
                                    }
                                    
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    //display the plant type and its image
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
        //retrieve the list of plants from the plants object and setup the list of image urls
        .onAppear(perform: {
            listOfPlants()
            self.fullUrlList = listOfImages(plantList: plants.plantList)
        })
    }
    
    //get a string list of plants from the plants object
    func listOfPlants() {
        plantList = []
        for plant in plants.plantList {
            plantList.append(plant.plantType)
        }
    }
    //get list of image urls from the plants object
    func listOfImages(plantList: [Plant]) -> [String] {
        var urlList: [String] = []
        for plant in plantList {
            urlList.append(plant.imageURL)
        }
        return urlList
    }
    //function to find a correspond plant object given a plant type string
    func getSelectedPlant(selectedPlant: String) -> Plant {
        for plant in plants.plantList {
            if(plant.plantType == selectedPlant) {
                return plant
            }
        }
        print("_-_-_-_-_-_-_-_-\nerror occured\n_-_-_-_-_-_-_-_-")
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up", imageURL: "")
    }
}
