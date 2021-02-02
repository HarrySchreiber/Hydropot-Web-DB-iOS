//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddPlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @Binding var showModal: Bool
    @State var plantName = ""
    @State var plantType = ""
    @State var idealTemperature: String = ""
    @State var idealMoisture: String = ""
    @State var idealLightLevel: String = ""

    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    VStack(){
                        Image(systemName: "camera.circle")
                            .frame(alignment: .center)
                            .font(.system(size: geometry.size.width/2))
                        Text("Add Photo")
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
                    self.showModal.toggle()
                }) {
                HStack {
                    Text("Confirm")
                }
            })

        }
    }
}

