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
    @ObservedObject var ideals: Ideals = Ideals(idealTemperatureHigh: "", idealTemperatureLow: "", idealMoistureHigh: "", idealMoistureLow: "", idealLightLevelLow: "", idealLightLevelHigh: "", plantName: "", plantSelected: "Plant Types", notificationFrequency: 2)// ideal values for pages
    @Binding var showModal: Bool //modal being shown or not
    @State var failed: Bool = false //failed boolean for displaying alert
    @State var isShowPicker: Bool = false //showing the picture picker
    @State var image: Image? = Image(systemName: "camera.circle") //default image
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle") //other default user image
    @State var tempURL = "" //temp url to know if the image has been selected by user
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .onTapGesture {
                        hideKeyboard()
                    }
                VStack{
                    ScrollView {
                        ZStack {
                            Color.white
                                .onTapGesture {
                                    hideKeyboard()
                                }
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
                                .padding(.bottom, 3)
                                HStack{
                                    //name of the plant
                                    TextField("Plant Name", text: $ideals.plantName)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                .padding(.bottom, 3)
                                //show the image picker when toggled
                                .sheet(isPresented: $isShowPicker) {
                                    ImagePicker(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                                }
                                HStack{
                                    //pot id for user to input
                                    TextField("Claim Pot ID", text: $ideals.potID)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                .padding(.bottom, 3)
                                ZStack{
                                    //if defualt plant type
                                    if (ideals.plantSelected == "Plant Types"){
                                        //display empty
                                        Text("\(ideals.plantSelected)")
                                            //styling
                                            .font(.system(size: UIScreen.regTextSize))
                                            .foregroundColor(.black)
                                            .opacity(0.3)
                                            .padding(6)
                                            .buttonStyle(PlainButtonStyle())
                                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                            .border(Color.black.opacity(0.5))
                                    }
                                    //if not default
                                    else {
                                        //display actual plant type
                                        Text("\(ideals.plantSelected)")
                                            .font(.system(size: UIScreen.regTextSize))
                                            .foregroundColor(.black)
                                            .padding(6)
                                            .buttonStyle(PlainButtonStyle())
                                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                            .border(Color.black.opacity(0.5))
                                    }
                                    //link the plant type field to the adding page
                                    NavigationLink(destination: AddEditPlantList(ideals: ideals, plants: plants)){
                                        //chev image to let user know to press
                                        Image(systemName: "chevron.right")
                                            //styling
                                            .foregroundColor(.black)
                                            .padding(6)
                                            .font(.system(size: UIScreen.title3TextSize))
                                            .clipShape(Circle())
                                            .padding(.leading, UIScreen.cheveronSize)
                                    }
                                }
                                .padding(.bottom, 3)
                                HStack{
                                    Stepper("Reservoir reminder every: \(ideals.notificationFrequency) weeks", value: $ideals.notificationFrequency, in: 1...12)
                                        //styling
                                        .font(.system(size: UIScreen.resFont))
                                        .foregroundColor(.black)
                                        .padding(6)
                                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                .padding(.bottom, 6)
                                HStack {
                                    //moisture to be entered
                                    Text("Moisture (%)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .foregroundColor(getTextColor(bool: ideals.isMoistGood))
                                    //low moisture
                                    TextField("Low", text: $ideals.idealMoistureLow)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isMoistHighGood))
                                    //seperator
                                    Text("-")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.dashSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                    //high moisture
                                    TextField("High", text: $ideals.idealMoistureHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isMoistLowGood))

                                }
                                .padding(6)
                                HStack{
                                    //light to be entered
                                    Text("Light (lm)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .foregroundColor(getTextColor(bool: ideals.isLightGood))
                                    
                                    //low light
                                    TextField("Low", text: $ideals.idealLightLevelLow)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isLightLowGood))
                                    //seperator
                                    Text("-")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.dashSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                    //high to be entered
                                    TextField("High", text: $ideals.idealLightLevelHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isLightHighGood))
                                }
                                .padding(6)
                                HStack {
                                    //temperature to be entered
                                    Text("Temp (°F)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .foregroundColor(getTextColor(bool: ideals.isTempGood))
                                    //low temp to be entered
                                    TextField("Low", text: $ideals.idealTemperatureLow)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isTempLowGood))
                                    //seperator
                                    Text("-")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: UIScreen.dashSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                    //high temp to be entered
                                    TextField("High", text: $ideals.idealTemperatureHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                        .foregroundColor(getTextColor(bool: ideals.isTempHighGood))
                                }
                                .padding(6)
                            }
                            Spacer()
                        }
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
                            if (ideals.plantName != "" && ideals.idealTemperatureHigh != "" && ideals.idealTemperatureLow != "" && ideals.idealMoistureHigh != "" && ideals.idealMoistureLow != "" && ideals.idealLightLevelHigh != "" && ideals.idealLightLevelLow != ""){
                                
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
                                    .foregroundColor(confirmDisabled ? .gray : .white)
                            }
                            //present alert if toggled
                            .alert(isPresented: $failed) {
                                //alert
                                Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
                            }
                        }
                        .disabled(confirmDisabled))
            }
            
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
        let pot = Pot(plantName: ideals.plantName, plantType: ideals.plantSelected,
                      idealTempHigh: Int(ideals.idealTemperatureHigh) ?? 0, idealTempLow: Int(ideals.idealTemperatureLow) ?? 0,
                      idealMoistureHigh: Int(ideals.idealMoistureHigh) ?? 0, idealMoistureLow: Int(ideals.idealMoistureLow) ?? 0,
                      idealLightHigh: Int(ideals.idealLightLevelHigh) ?? 0, idealLightLow: Int(ideals.idealLightLevelLow) ?? 0,
                      lastWatered: Date(), records: [], notifications: [], curTemp: 0, curLight: 0, curMoisture: 0,
                      id: ideals.potID, automaticWatering: true, image: "", potId: ideals.potID, lastFilled: Date(), notiFilledFrequency: ideals.notificationFrequency)
        
        //if we do have an image
        if (tempURL != ""){
            //upload the image with the function to s3
            user.uploadImage(encoding: encodedImage, ext: ext, pot: pot) {
                if user.loggedIn {
                    //add the new plant
                    user.addPlant(pot: pot)
                }
            }
        }
        //if we don't have a image
        else {
            //add a new plant
            user.addPlant(pot: pot)
        }
    }
    
    /// function to encode jpeg images
    ///
    /// - Parameters:
    ///     - bool: if supposed to be red or green
    ///
    /// - Returns:
    ///     the correct color of the text
    func getTextColor(bool: Bool) -> Color{
        //if we are supposed to be green
        if(bool) {
            //return green
            return Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0)
        }
        //return red
        return Color.red
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
    
    //Evaluates to true when the add fields are not properly formatted
    var confirmDisabled: Bool{
        ideals.plantName.isEmpty ||
        ideals.potID.isEmpty ||
        (ideals.plantSelected == "Plant Types") ||
        ideals.idealTemperatureHigh.isEmpty ||
        ideals.idealTemperatureLow.isEmpty ||
            !isInt(num: ideals.idealTemperatureHigh) ||
            !isInt(num: ideals.idealTemperatureLow) ||
            Int(ideals.idealTemperatureHigh) ?? 0 < Int(ideals.idealTemperatureLow) ?? 0 ||
            ideals.idealMoistureHigh.isEmpty ||
            ideals.idealMoistureLow.isEmpty ||
            !isInt(num: ideals.idealMoistureHigh) ||
            !isInt(num: ideals.idealMoistureLow) ||
            Int(ideals.idealMoistureHigh) ?? 0 < Int(ideals.idealMoistureLow) ?? 0 ||
            Int(ideals.idealMoistureHigh) ?? 0 > 100 ||
            Int(ideals.idealMoistureHigh) ?? 0 < 0 ||
            Int(ideals.idealMoistureLow) ?? 0 > 100 ||
            Int(ideals.idealMoistureLow) ?? 0 < 0 ||
            ideals.idealLightLevelHigh.isEmpty ||
            ideals.idealLightLevelLow.isEmpty ||
            !isInt(num: ideals.idealLightLevelHigh) ||
            !isInt(num: ideals.idealLightLevelLow) ||
            Int(ideals.idealLightLevelHigh) ?? 0 < Int(ideals.idealLightLevelLow) ?? 0
    }
    
    ///Evalueates if a string is an integer
    ///
    /// - Parameters:
    ///     - num: String of the number to be evaluated
    func isInt(num: String) -> Bool{
        return Int(num) != nil
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

