//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct EditPlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    @ObservedObject var pot: Pot
    @Binding var showModal: Bool
    @State var plantName = ""
    @State var plantType = ""
    @State var idealTemperatureHigh: String = ""
    @State var idealMoistureHigh: String = ""
    @State var idealLightLevelHigh: String = ""
    @State var idealTemperatureLow: String = ""
    @State var idealMoistureLow: String = ""
    @State var idealLightLevelLow: String = ""
    @State var plantSelected: String = ""

    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    VStack(){
                        Image(systemName: "camera.circle")
                            .frame(alignment: .center)
                            .font(.system(size: geometry.size.width/2))
                        Text("Edit Photo")
                            .frame(alignment: .center)
                            .padding(.bottom, 3)
                        HStack{
                            TextField("Plant Name", text: $plantName).onAppear() {
                                if (plantName == ""){
                                    plantName = pot.plantName
                                }
                            }
                                .padding(6)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                        }
                            .padding(.leading, geometry.size.height/30)
                        ZStack{
                            if (plantSelected == ""){
                                Text("\(pot.plantType)")
                                    .foregroundColor(.black)
                                    .padding(6)
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            else {
                                Text("\(plantSelected)")
                                    .foregroundColor(.black)
                                    .padding(6)
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            NavigationLink(destination: AddEditPlantList(plants: plants, plantSelected: $plantSelected, idealTemperatureHigh: $idealTemperatureHigh, idealMoistureHigh: $idealMoistureHigh, idealLightLevelHigh: $idealLightLevelHigh, idealTemperatureLow: $idealTemperatureLow, idealMoistureLow: $idealMoistureLow, idealLightLevelLow: $idealLightLevelLow)) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                                    .padding(6)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .padding(.leading, geometry.size.width * 0.8)
                            }
                        }
                            .padding(.leading, geometry.size.height/30)
                        HStack {
                            Text("Moisture")
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height/12, alignment: .leading)
                            TextField("Low", text: $idealMoistureLow)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                            Text(" - ")
                                .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                            TextField("High", text: $idealMoistureHigh)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                            
                        }
                            .padding(.leading, geometry.size.height/30)
                        HStack{
                            Text("Light")
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height/12, alignment: .leading)
                            TextField("Low", text: $idealLightLevelLow)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                            Text(" - ")
                                .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                            TextField("High", text: $idealLightLevelHigh)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                            
                            
                        }
                            .padding(.leading, geometry.size.height/30)
                        HStack{
                            Text("Temperature")
                                .frame(width: geometry.size.width * 0.3, height: geometry.size.height/12, alignment: .leading)
                            
                            TextField("Low", text: $idealTemperatureLow)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                            Text(" - ")
                                .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                            TextField("High", text: $idealTemperatureHigh)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                        }
                            .padding(.leading, geometry.size.height/30)
                    }
                    .cornerRadius(6)
                    Spacer()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    self.showModal.toggle()
                }) {
                    HStack {
                        Text("Cancel")
                    }
            }, trailing:
                Button(action: {
                    if (plantName != "" && plantSelected != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        pot.editPlant(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0)
                        
                        user.editPot(pot: pot)
                        self.showModal.toggle()
                    }
                    else if (plantName != "" && pot.plantType != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        pot.editPlant(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0)
                        
                        print(pot.plantName)
                        print(pot.plantType)
                        print(pot.id)
                        print(pot.idealMoistureLow)
                        user.editPot(pot: pot)
                        self.showModal.toggle()
                    }
                }) {
                HStack {
                    Text("Confirm")
                }
            })

        }.onAppear() {
            plantSelected = pot.plantType
            idealMoistureLow = String(pot.idealMoistureLow)
            idealMoistureHigh = String(pot.idealMoistureHigh)
            idealTemperatureLow = String(pot.idealTempLow)
            idealTemperatureHigh = String(pot.idealTempHigh)
            idealLightLevelLow = String(pot.idealLightLow)
            idealLightLevelHigh = String(pot.idealLightHigh)
        }
    }
}


