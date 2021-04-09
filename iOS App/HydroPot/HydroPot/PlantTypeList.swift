//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

/*
    list for plant type struct
 */
struct PlantTypeList: View {
    @State var plants : Plants
    
    @State private var searchQuery: String = "" //string searched by the user
    @State private var plantList = [String]()   //a string list of all the plants (for displaying)
    @State private var searchedPlantList = [String]()   //list of plants that match search criteria
    @State private var displayedList = [String]()       //list of plants that match search and filter - what is displayed
    @State private var searching = false        //boolean for if user is searching
    @State private var filtering = false        //boolean for if user is filtering
    
    //array of boolean tuples for low, medium and high moisture, light and temperature
    //(moisture low, medium high), then (light l, m, h), then (temperature l,m,h)
    @State var filteredValues: [(low: Bool, med: Bool, high: Bool)] = [(false,false,false),(false,false,false),(false,false,false)]
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
                
                // List of plants
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
                        } else {
                            //if the user is searching or filtering, loop through the trimmed down list of plants,
                            //otherwise show the complete list of plants
                            ForEach((searching || filtering) ? (0..<displayedList.count) : (0..<plantList.count), id: \.self) { row in
                                //setup nav link
                                if (getSelectedPlant(selectedPlant: ((filtering || searching) ? displayedList[row] : plantList[row])).plantType != "Other"){
                                    NavigationLink(
                                        destination:
                                            PlantTypePage(plant: getSelectedPlant(selectedPlant: ((filtering || searching) ? displayedList[row] : plantList[row]))),
                                        
                                        label: {
                                            ListCell(text: bindDisplayList[row], url: bindUrlList[row])
                                                .frame(height: UIScreen.plantTypeListImageSize)
                                                .padding(.top)
                                        })
                                        .simultaneousGesture(TapGesture().onEnded {
                                            // Hide Keyboard after pressing a Cell
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        })
                                }
                            }
                        }

                    }
                }
            }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Plant Types") // Navigation Bar Title
        }
        //retrieve the list of plants from the plants object and setup the list of image urls
        .onAppear(perform: {
            self.plantList = listOfPlants(plantList: plants.plantList)
            self.fullUrlList = listOfImages(plantList: plants.plantList)
        })
        .gesture(DragGesture().onChanged {_ in 
            hideKeyboard()
        })
    }
    
    //get a string list of plants from the plants object
    func listOfPlants(plantList: [Plant]) -> [String] {
        var stringList : [String] = []
        for plant in plantList {
            stringList.append(plant.plantType)
        }
        return stringList
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
        print("----- error occured selecting plant type -----")
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up", imageURL: "", citation: "") 
    }
    
}

//function for filtering list of plants based off users input (stored in array of boolean tuples
func filterList(filteredValues: [(low:Bool, med: Bool, high:Bool)], displayedList: inout [String], plants: Plants, searchedList: [String], urlList: inout [String]) {
    //setup temporary list
    var list = [String]()
    //moisture values (lower and upper bounds for medium level moisture)
    let moistureTuple = (20,35)
    //light values (lower and upper bounds for medium level light)
    let lightTuple = (2500,8000)
    //temperature values (lower and upper bounds for medium level temperature)
    let tempTuple = (55,70)
    
    //boolean logic for if moisture, light or temperature are not selected
    let mNotSelected = !filteredValues[0].low && !filteredValues[0].med && !filteredValues[0].high
    let lNotSelected = !filteredValues[1].low && !filteredValues[1].med && !filteredValues[1].high
    let tNotSelected = !filteredValues[2].low && !filteredValues[2].med && !filteredValues[2].high
    
    //loop through each plant
    for plant in plants.plantList {
        //true if plant is in the selected moisture range(s)
        let lowMoisture = (filteredValues[0].low && plant.idealMoistureHigh <= moistureTuple.0 && plant.idealMoistureHigh != -1000)
        let medMoisture = (filteredValues[0].med && (plant.idealMoistureHigh <= moistureTuple.1 && plant.idealMoistureHigh > moistureTuple.0))
        let highMoisture = (filteredValues[0].high && plant.idealMoistureHigh > moistureTuple.1)
        
        //true if plant is in the selected light range(s)
        let lowLight = (filteredValues[1].low && plant.idealLightHigh <= lightTuple.0 && plant.idealMoistureHigh != -1000)
        let medLight = (filteredValues[1].med && (plant.idealLightHigh <= lightTuple.1 && plant.idealLightHigh > lightTuple.0))
        let highLight = (filteredValues[1].high && plant.idealLightHigh > lightTuple.1)
        
        //true if plant is in the selected temperature range(s)
        let lowTemp = (filteredValues[2].low && plant.idealTempHigh <= tempTuple.0 && plant.idealMoistureHigh != -1000)
        let medTemp = (filteredValues[2].med && (plant.idealTempHigh <= tempTuple.1 && plant.idealTempHigh > tempTuple.0))
        let highTemp = (filteredValues[2].high && plant.idealTempHigh > tempTuple.1)
        
        //setup if the values are in any of the ranges
        let inMoistureRange = mNotSelected || lowMoisture || medMoisture || highMoisture
        let inLightRange = lNotSelected || lowLight || medLight || highLight
        let inTempRange = tNotSelected || lowTemp || medTemp || highTemp
        
        //if the plant matches the moisture filter section
        if(inMoistureRange && inLightRange && inTempRange) {
            //add plant to temp list
            list.append(plant.plantType)
        }
    }
    //convert list to set, convert searchedList to set
    let set1:Set<String> = Set(list)
    let set2:Set<String> = Set(searchedList)
    
    //find plants that match the filters and search
    let displaySet = set1.intersection(set2)
    
    //save the combined list
    displayedList = displaySet.sorted()
    urlList = updateImages(displayedList: displayedList, plants: plants)

    
}

//update the image list based on searching/filtering
func updateImages(displayedList: [String], plants: Plants) -> [String] {
    var urlList: [String] = []
    for i in 0..<plants.plantList.count {
        if(displayedList.contains(plants.plantList[i].plantType)) {
            urlList.append(plants.plantList[i].imageURL)
        }
    }
    return urlList
}

struct ListCell: View {
    
    @Binding var text: String   //text to display in list
    @Binding var url: String    //image to display alongside text
    
    var body: some View {
        VStack() {
            Spacer()
            ZStack {
                HStack (){
                    //if there is a photo for this plant
                    if (url != "" ){
                        //display the plant image
                        URLImage(url: URL(string: url)!) { image in
                            VStack {
                                //plant image
                                image
                                    //styling
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.leading, 15)
                                    .foregroundColor(.black)
                            }
                            //styling
                            .frame(width: UIScreen.plantTypeListImageSize, height: UIScreen.plantTypeListImageSize)
                        }
                    }
                    //if there is not a photo for this plant
                    else {
                        VStack {
                            //default image
                            Image(systemName: "photo")
                                //styling
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 15)
                                .foregroundColor(.black)
                        }
                        //styling
                        .frame(width: UIScreen.plantTypeListImageSize, height: UIScreen.plantTypeListImageSize)
                    }
                    //display the plant type name
                    Text(text)
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            Spacer()
            Divider()
        }
    }
}
