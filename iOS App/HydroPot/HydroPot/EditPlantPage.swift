//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct EditPlantPage: View {
    @ObservedObject var user: GetUser
    @State var plantName = ""
    @State var plantType = ""
    @State var idealTemperature: String = ""
    @State var idealMoisture: String = ""
    @State var idealLightLevel: String = ""
    
    var body: some View {
        GeometryReader{ geometry in
            VStack(){
                Image(systemName: "camera.circle.fill")
                    .frame(alignment: .center)
                    .font(.system(size: geometry.size.width/2))
                Text("Edit Photo")
                    .frame(alignment: .center)
                    .padding(.bottom, 3)
                TextField("Plant Name", text: $plantName)
                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                    .border(Color.black.opacity(0.5))
                    .padding(.leading, 20)
                TextField("Plant Type", text: $plantType)
                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                    .border(Color.black.opacity(0.5))
                    .padding(.leading, 20)
                TextField("Ideal Temperature", text: $idealTemperature)
                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                    .border(Color.black.opacity(0.5))
                    .padding(.leading, 20)
                TextField("Plant Moisture", text: $idealMoisture)
                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                    .border(Color.black.opacity(0.5))
                    .padding(.leading, 20)
                TextField("Ideal Light Level", text: $idealLightLevel)
                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                    .border(Color.black.opacity(0.5))
                    .padding(.leading, 20)
            }
            .cornerRadius(6)
            Spacer()
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}


