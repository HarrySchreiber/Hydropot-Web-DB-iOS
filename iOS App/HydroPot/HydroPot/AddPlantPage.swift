//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddPlantPage: View {
    @ObservedObject var user: GetUser
    @State var plantName = ""
    @State var plantType = ""
    @State var idealTemperature: String = ""
    @State var idealMoisture: String = ""
    @State var idealLightLevel: String = ""
    
    var body: some View {
        GeometryReader { geomOne in
            VStack {
                Image(systemName: "camera.circle.fill")
                    .font(.system(size: 150))
                NavigationView {
                    VStack(alignment: .leading){
                        TextField("Plant Name", text: $plantName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.black.opacity(0.5))
                            .padding(.leading, 3)
                        TextField("Plant Type", text: $plantType)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.black.opacity(0.5))
                            .padding(.leading, 3)
                        TextField("Ideal Temperature", text: $idealTemperature)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.black.opacity(0.5))
                            .padding(.leading, 3)
                        TextField("Plant Moisture", text: $idealMoisture)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.black.opacity(0.5))
                            .padding(.leading, 3)
                        TextField("Ideal Light Level", text: $idealLightLevel)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.black.opacity(0.5))
                            .padding(.leading, 3)
                    }
                }
            }
            .frame(height: geomOne.size.height * 0.7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .cornerRadius(6)
        }
    }
}
