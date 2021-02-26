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
    @ObservedObject var plants: Plants
    @Binding var showModal: Bool
    @State var plantName = ""
    @State var idealTemperatureHigh: String = ""
    @State var idealMoistureHigh: String = ""
    @State var idealLightLevelHigh: String = ""
    @State var idealTemperatureLow: String = ""
    @State var idealMoistureLow: String = ""
    @State var idealLightLevelLow: String = ""
    @State var plantSelected: String = "Plant Type"
    @State var failed: Bool = false
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image(systemName: "camera.circle")
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle")
    @State var tempURL = ""
    
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    VStack(){
                        Button(action: {
                            withAnimation {
                                self.isShowPicker.toggle()
                            }
                        }) {
                            VStack {
                                image?
                                    .resizable()
                                    .scaledToFit()
                                    .frame(alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                            }
                            .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                        }
                        .foregroundColor(.black)
                            .frame(alignment: .center)
                            .padding(.bottom, 3)
                        Text("Add Photo")
                            .font(.system(size: UIScreen.regTextSize))

                            .frame(alignment: .center)
                            .padding(.bottom, 3)
                        HStack{
                            TextField("Plant Name", text: $plantName)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                        }
                        .sheet(isPresented: $isShowPicker) {
                            ImagePickerTwo(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                         }
                        .padding(.leading, geometry.size.height/30)
                        ZStack{
                            if (plantSelected == "Plant Type"){
                                Text("\(plantSelected)")
                                    .foregroundColor(.black)
                                    .opacity(0.3)
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.showModal.toggle()
                }) {
                    HStack {
                        Text("Cancel")
                            .font(.system(size: UIScreen.regTextSize))
                    }
            }, trailing:
                Button(action: {
                    if (plantName != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        
                        var encoding = encodePicturePNG(image: userIntefaceImage!)
                        
                        if (encoding == ""){
                            encoding = encodePictureJPEG(image: userIntefaceImage!)
                            addImage(encodedImage: encoding, ext: "jpeg")
                        }
                        else {
                            addImage(encodedImage: encoding, ext: "png")
                        }

                        self.showModal.toggle()
                    }
                    else {
                        failed = true
                    }
                }) {
                HStack {
                    Text("Confirm")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .alert(isPresented: $failed) {
                    Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
                }
            })
        }
    }
    
    func addImage(encodedImage: String, ext: String) {
        
        let pot = Pot(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0, lastWatered: Date(), records: [], notifications: [], resLevel: 40, curTemp: 0, curLight: 0, curMoisture: 0, id: UUID().uuidString, automaticWatering: true, image: "")
        
        user.uploadImage(encoding: encodedImage, ext: ext, pot: pot) {
            if user.loggedIn {
                print(pot.image)
                user.addPlant(pot: pot)
            }
        }
    }
    
    func encodePictureJPEG (image: UIImage) -> String{
        
        guard let imageData = image.pngData() else {
            return ""
        }
        
        return imageData.base64EncodedString()
        
    }
    
    func encodePicturePNG (image: UIImage) -> String{
        
        guard let imageDataPNG = image.pngData() else {
            return ""
        }
        
        return imageDataPNG.base64EncodedString()
        
    }

}
