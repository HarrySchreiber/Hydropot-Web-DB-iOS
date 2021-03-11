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
    @State var potID = ""
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
                    ScrollView {
                        VStack{
                            HStack{
                                Button(action: {
                                    withAnimation {
                                        self.isShowPicker.toggle()
                                    }
                                }) {
                                    VStack{
                                        VStack {
                                            image?
                                                .resizable()
                                                .scaledToFit()
                                                .frame(alignment: .center)
                                                .clipped()
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                .shadow(radius: 10)
                                        }
                                        .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                                        .padding(.bottom, UIScreen.addPhotoPadding)
                                        Text("Add Photo")
                                            .font(.system(size: UIScreen.regTextSize))
                                            .frame(alignment: .center)
                                    }
                                }
                                .foregroundColor(.black)
                                .padding(.top)
                            }
                            .padding(.bottom)
                            HStack{
                                TextField("Plant Name", text: $plantName)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            .sheet(isPresented: $isShowPicker) {
                                ImagePickerTwo(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                            }
                            HStack{
                                TextField("Pot ID", text: $potID)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            
                            ZStack{
                                if (plantSelected == "Plant Type"){
                                    Text("\(plantSelected)")
                                        .font(.system(size: UIScreen.regTextSize))
                                        .foregroundColor(.black)
                                        .opacity(0.3)
                                        .padding(6)
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                else {
                                    Text("\(plantSelected)")
                                        .font(.system(size: UIScreen.regTextSize))
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
                                        .font(.system(size: UIScreen.title3TextSize))
                                        .clipShape(Circle())
                                        .padding(.leading, geometry.size.width * 0.8)
                                }
                            }
                            
                            HStack {
                                Text("Moisture (%)")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                TextField("Low", text: $idealMoistureLow)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                Text("-")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                TextField("High", text: $idealMoistureHigh)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                
                                
                            }
                            HStack{
                                Text("Light (lm)")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                TextField("Low", text: $idealLightLevelLow)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                Text("-")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                TextField("High", text: $idealLightLevelHigh)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                
                                
                            }
                            HStack {
                                Text("Temp (°F)")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                TextField("Low", text: $idealTemperatureLow)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                Text("-")
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                TextField("High", text: $idealTemperatureHigh)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                        }
                        Spacer()
                    }
                    .padding(.leading, geometry.size.height/30)
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
                                                
                                                
                                                let encoding = encodePictureJPEG(image: userIntefaceImage!)
                                                addImage(encodedImage: encoding, ext: "jpeg")
                                                
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
        
        guard let imageData = image.jpeg(UIImage.JPEGQuality(rawValue: 0)!) else {
            return ""
        }
        
        return imageData.base64EncodedString()
        
    }
    
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
