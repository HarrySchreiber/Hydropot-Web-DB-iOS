//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AddPlantPage: View {

    @Environment(\.presentationMode) var presentationMode //presentation mode for dismissal
    @ObservedObject var user: GetUser //user that was passed
    @ObservedObject var plants: Plants //plants list
    @Binding var showModal: Bool //modal being shown or not
    @State var plantName = "" //name of the plat
    @State var idealTemperatureHigh: String = "" //temp high for plant type
    @State var idealTemperatureLow: String = "" //temp low for plant type
    @State var idealMoistureHigh: String = "" //moisture high for plant type
    @State var idealMoistureLow: String = "" //moisture low for plant type
    @State var idealLightLevelHigh: String = "" //light high for plant type
    @State var idealLightLevelLow: String = "" //light low for plant type
    @State var plantSelected: String = "Plant Type" //what plant type has been selected
    @State var failed: Bool = false //failed boolean for displaying alert
    @State var isShowPicker: Bool = false //showing the picture picker
    @State var image: Image? = Image(systemName: "camera.circle") //default image
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle") //other default user image
    @State var tempURL = "" //temp url to know if the image has been selected by user
    @State var potID = "" //id of the pot
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    ScrollView {
                        VStack{
                            HStack{
                                Button(action: {
                                    withAnimation {
                                        //show image picker
                                        self.isShowPicker.toggle()
                                    }
                                }) {
                                    VStack{
                                        VStack {
                                            //image to be displayed
                                            image?
                                                //styling
                                                .resizable()
                                                .scaledToFit()
                                                .frame(alignment: .center)
                                                .clipped()
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                .shadow(radius: 10)
                                        }
                                        //styling
                                        .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                                        .padding(.bottom, UIScreen.addPhotoPadding)
                                        //letting user know to add
                                        Text("Add Photo")
                                            .font(.system(size: UIScreen.regTextSize))
                                            .frame(alignment: .center)
                                    }
                                }
                                //styling
                                .foregroundColor(.black)
                                .padding(.top)
                            }
                            .padding(.bottom)
                            HStack{
                                //name of the plant
                                TextField("Plant Name", text: $plantName)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            //show the image picker when toggled
                            .sheet(isPresented: $isShowPicker) {
                                ImagePickerTwo(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                            }
                            HStack{
                                //pot id for user to input
                                TextField("Pot ID", text: $potID)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            ZStack{
                                //if defualt plant type
                                if (plantSelected == "Plant Type"){
                                    //display empty
                                    Text("\(plantSelected)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .foregroundColor(.black)
                                        .opacity(0.3)
                                        .padding(6)
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                //if not default
                                else {
                                    //display actual plant type
                                    Text("\(plantSelected)")
                                        .font(.system(size: UIScreen.regTextSize))
                                        .foregroundColor(.black)
                                        .padding(6)
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                //link the plant type field to the adding page
                                NavigationLink(destination: AddEditPlantList(plants: plants, plantSelected: $plantSelected, idealTemperatureHigh: $idealTemperatureHigh, idealMoistureHigh: $idealMoistureHigh, idealLightLevelHigh: $idealLightLevelHigh, idealTemperatureLow: $idealTemperatureLow, idealMoistureLow: $idealMoistureLow, idealLightLevelLow: $idealLightLevelLow)) {
                                    //chev image to let user know to press
                                    Image(systemName: "chevron.right")
                                        //styling
                                        .foregroundColor(.black)
                                        .padding(6)
                                        .font(.system(size: UIScreen.title3TextSize))
                                        .clipShape(Circle())
                                        .padding(.leading, geometry.size.width * 0.8)
                                }
                            }
                            HStack {
                                //moisture to be entered
                                Text("Moisture (%)")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                //low moisture
                                TextField("Low", text: $idealMoistureLow)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                //seperator
                                Text("-")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                //high moisture
                                TextField("High", text: $idealMoistureHigh)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            HStack{
                                //light to be entered
                                Text("Light (lm)")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                //low light
                                TextField("Low", text: $idealLightLevelLow)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                //seperator
                                Text("-")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                //high to be entered
                                TextField("High", text: $idealLightLevelHigh)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                            }
                            HStack {
                                //temperature to be entered
                                Text("Temp (°F)")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                //low temp to be entered
                                TextField("Low", text: $idealTemperatureLow)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                //seperator
                                Text("-")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize)).bold()
                                    .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                    .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                //high temp to be entered
                                TextField("High", text: $idealTemperatureHigh)
                                    //styling
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
            //nav bar things
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    //dismiss the modal
                    self.showModal.toggle()
                }) {
                    HStack {
                        //cancer text
                        Text("Cancel")
                            .font(.system(size: UIScreen.regTextSize))
                    }
            }, trailing:
                //confirm button
                Button(action: {
                    //if all values are entered
                    if (plantName != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        
                        //encode the image
                        let encoding = encodePictureJPEG(image: userIntefaceImage!)
                        
                        //add the image
                        addImage(encodedImage: encoding, ext: "jpeg")

                        //dismiss the modal
                        self.showModal.toggle()
                    }
                    //else
                    else {
                        //display alert
                        failed = true
                    }
                }) {
                HStack {
                    //confirm text for button
                    Text("Confirm")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                }
                //present alert if toggled
                .alert(isPresented: $failed) {
                    //alert 
                    Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
                }
            })
        }
    }
    
    /// add encode encoded image to the db
    ///
    /// - Parameters:
    ///     - encodedImage: image encoding to be uploaded
    ///     - ext: extension of the image
    ///
    func addImage(encodedImage: String, ext: String) {
        
        //assign a new pot
        let pot = Pot(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0, lastWatered: Date(), records: [], notifications: [], resLevel: 40, curTemp: 0, curLight: 0, curMoisture: 0, id: UUID().uuidString, automaticWatering: true, image: "")
        
        //upload the image with the function to s3
        user.uploadImage(encoding: encodedImage, ext: ext, pot: pot) {
            if user.loggedIn {
                //add the new plant
                user.addPlant(pot: pot)
            }
        }
    }
    
    /// function to encode jpeg images
    ///
    /// - Parameters:
    ///     - image: image that is being converted
    ///
    /// - Returns:
    ///     the encoded image data
    func encodePictureJPEG (image: UIImage) -> String{
        
        //if we can't return encoded
        guard let imageData = image.jpeg(UIImage.JPEGQuality(rawValue: 0)!) else {
            return ""
        }
        
        //else return encoded
        return imageData.base64EncodedString()
        
    }
    
    
}

/*
    extention for the ui image styling
 */
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0 //lowest quality jpeg conversion
        case low     = 0.25 //low quality jpeg conversion
        case medium  = 0.5 //medium quality jpeg conversion
        case high    = 0.75 //high quality jpeg conversion
        case highest = 1 //highest quality jpeg conversion
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    ///
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
