//
//  PlantTypeList.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

struct PlantTypeList: View {
    @State var plants : Plants
    @State private var searchQuery: String = ""
    
    @State private var plantList = [String]()
    @State private var searchedPlantList = [String]()
    @State private var searching = false
    
    //array of boolean tuples for low, medium and high moisture, light and temperature
    //(moisture low, medium high), then (light l, m, h), then (temperature l,m,h)
    @State var filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
    
    var body: some View {
        let filterBinding = Binding<[(Bool,Bool,Bool)]>(get: {
            self.filteredValues
        }, set: {
            self.filteredValues = $0
            filterList(filteredValues: self.filteredValues)
        })
        
        NavigationView {
            VStack(spacing: 0) {
                // SearchBar
                SearchBar(searching: $searching, mainList: $plantList, searchedList: $searchedPlantList, filteredValues: filterBinding)
                
                // List
                ScrollView {
                    VStack(spacing: 0) {
                        if(plantList.count == 0) {
                            Text("No plant types match your filter(s). \nTry filtering for something else!")
                                .font(.system(size: UIScreen.regTextSize))
                                .bold()
                                .italic()
                                .padding()
                                .foregroundColor(.gray)
                                .navigationBarTitle("Notifications", displayMode: .inline)
                        }else {
                            ForEach(searching ? (0..<searchedPlantList.count) : (0..<plantList.count), id: \.self) { row in
                                NavigationLink(
                                    destination:
                                        PlantTypePage(plant: getSelectedPlant(selectedPlant: (searching ? searchedPlantList[row] : plantList[row]))),
                                    
                                    label: {
                                        ListCell(text: searching ? searchedPlantList[row] : plantList[row], url: getSelectedPlant(selectedPlant: (searching ? searchedPlantList[row] : plantList[row])).imageURL)
                                            .frame(height: UIScreen.homeImageSize/1.75)
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
            }.navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Plant Types") // Navigation Bar Title
        }
        .onAppear(perform: {
            self.plantList = listOfPlants(plantList: plants.plantList)
        })
    }
    
    func listOfPlants(plantList: [Plant]) -> [String] {
        var stringList : [String] = []
        for plant in plantList {
            stringList.append(plant.plantType)
        }
        return stringList
    }
    func getSelectedPlant(selectedPlant: String) -> Plant {
        for plant in plants.plantList {
            if(plant.plantType == selectedPlant) {
                return plant
            }
        }
        print("error occured selecting plant type\n_____------_____----_____")
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

struct ListCell: View {
    
    var text: String
    @State var url: String
    
    var body: some View {
        VStack() {
            Spacer()
            ZStack {
                HStack (){
                    URLImage(url: URL(string: url)!) { image in
                        VStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading, 15)
                                .foregroundColor(.black)
                        }
                        .frame(width: UIScreen.plantTypeListImageSize, height: UIScreen.plantTypeListImageSize)
                    }
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
struct SearchBar: View {
    @State private var searchInput: String = ""
    
    @Binding var searching: Bool
    @Binding var mainList: [String]
    @Binding var searchedList: [String]
    @State var viewFilter: Bool = false
    @Binding var filteredValues: [(Bool,Bool,Bool)]
    
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
                        .font(.system(size: UIScreen.regTextSize))
                        .modifier(TextFieldClearButton(searchInput: $searchInput, searching: $searching))
                        .accentColor(.black)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                
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
                    plantTypesFilter(showFilter: $viewFilter, filteredValues: $filteredValues)
                }
                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            }
            .frame(height: 50)
        }
    }
}
struct TextFieldClearButton: ViewModifier {
    @Binding var searchInput: String
    @Binding var searching: Bool
    func body(content: Content) -> some View {
        HStack {
            content
            
            if !searchInput.isEmpty {
                Button(
                    action: {
                        searching = false
                        searchInput = ""
                        // Hide Keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        
                    },
                    label: {
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
        }
    }
}
