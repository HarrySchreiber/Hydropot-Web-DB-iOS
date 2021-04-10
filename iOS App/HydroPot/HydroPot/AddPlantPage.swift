//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

/*
 view for adding plants
 */
struct AddPlantPage: View {
    
    @Environment(\.presentationMode) var presentationMode //presentation mode for dismissal
    @ObservedObject var user: GetUser //user that was passed
    @ObservedObject var plants: Plants //plants list
    @ObservedObject var ideals: Ideals = Ideals(idealTemperatureHigh: "", idealTemperatureLow: "", idealMoistureHigh: "", idealMoistureLow: "", idealLightLevelLow: "", idealLightLevelHigh: "", plantName: "", plantSelected: "Plant Types", notificationFrequency: 2)// ideal values for pages
    @State var tempValues = [(false, false, false, false),(false, false, false, false),(false, false, false, false), (false, false, false, false)] //default
    @Binding var showModal: Bool //modal being shown or not
    @State var failed: Bool = false //failed boolean for displaying alert
    @State var isShowPicker: Bool = false //showing the picture picker
    @State var image: Image? = Image(systemName: "camera.circle") //default image
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle") //other default user image
    @State var tempURL = "" //temp url to know if the image has been selected by user
    @State var addFailed = false //failed boolean for displaying id fail
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
                            VStack {
                                HStack{
                                    Button(action: {
                                        withAnimation {
                                            //show image picker
                                            self.isShowPicker.toggle()
                                        }
                                    }) {
                                        VStack {
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
                                VStack (alignment: .leading){
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
                                    //present alert if toggled
                                    .alert(isPresented: $addFailed) {
                                        //alert
                                        Alert(title: Text(""), message: Text("This pot ID has already been claimed"), dismissButton: .default(Text("Got it!")))
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
                                        NavigationLink(destination: AddEditPlantList(ideals: ideals, plants: plants, tempValues: $tempValues)){
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
                                    idealRanges(ideals: ideals, tempValues: $tempValues)
                                }
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
                    attemptAddPot(pot: pot)
    
                }
            }
        }
        //if we don't have a image
        else {
            attemptAddPot(pot: pot)
        }
    }
    
    /// callback for the login function designed to perform alert and load from db correctly
    ///
    /// - Parameters:
    ///     - pot: the pot to add
    func attemptAddPot(pot: Pot) {
        let count = user.pots.count
        //add a new plant
        user.addPlant(pot: pot) {
            if (count + 1 == user.pots.count){
                //dismiss the modal
                self.showModal.toggle()
            }
            else {
                addFailed = true
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

/*
 view for ideal ranges
 */
struct idealRanges: View {
    @ObservedObject var ideals: Ideals //ideals to modify
    @Binding var tempValues: [(Bool, Bool, Bool, Bool)]
    var body: some View {
        HStack {
            //moisture to be entered
            Text("Moisture (%)")
                //styling
                .font(.system(size: UIScreen.regTextSize)).bold()
                .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
        }
        Group {
            HStack {
                //button for filtering
                Button(action: {
                    //filter low only
                    ideals.idealMoistureLow = "10"
                    ideals.idealMoistureHigh = "20"
                    tempValues[0].0 = true
                    tempValues[0].1 = false
                    tempValues[0].2 = false
                    tempValues[0].3 = false
                }) {
                    //low filter
                    Text("Low")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[0].0))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[0].0), lineWidth: 2)
                        )
                }
                //filtering medium
                Button(action: {
                    //only medium
                    ideals.idealMoistureLow = "20"
                    ideals.idealMoistureHigh = "35"
                    tempValues[0].1 = true
                    tempValues[0].0 = false
                    tempValues[0].2 = false
                    tempValues[0].3 = false
                }) {
                    //medium filter
                    Text("Medium")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[0].1))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[0].1), lineWidth: 2)
                        )
                }
                //filtering high
                Button(action: {
                    //high filter only
                    ideals.idealMoistureLow = "35"
                    ideals.idealMoistureHigh = "90"
                    tempValues[0].2 = true
                    tempValues[0].0 = false
                    tempValues[0].1 = false
                    tempValues[0].3 = false
                }) {
                    //fiter high
                    Text("High")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[0].2))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[0].2), lineWidth: 2)
                        )
                }
                //filtering high
                Button(action: {
                    //high filter only
                    tempValues[0].3 = true
                    tempValues[0].0 = false
                    tempValues[0].1 = false
                    tempValues[0].2 = false
                    
                }) {
                    //fiter high
                    Text("Custom")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[0].3))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[0].3), lineWidth: 2)
                        )
                }
            }
            .padding(6)
            HStack {
                //text for range
                Text("Between")
                    .font(.system(size: UIScreen.regTextSize))
                    .frame(alignment: .center)
                //low moisture
                TextField("Low", text: $ideals.idealMoistureLow)
                    //styling
                    .font(.system(size: UIScreen.regTextSize))
                    .padding(6)
                    .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                    .border(getTextColor(bool: ideals.isMoistHighGood))
                    .foregroundColor(getTextColor(bool: ideals.isMoistHighGood))
                    .disabled(tempValues[0].3 == false)
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
                    .border(getTextColor(bool: ideals.isMoistLowGood))
                    .foregroundColor(getTextColor(bool: ideals.isMoistLowGood))
                    .disabled(tempValues[0].3 == false)
            }
        }
        .padding(.bottom)
        HStack{
            //light to be entered
            Text("Light (lm)")
                //styling
                .font(.system(size: UIScreen.regTextSize)).bold()
                .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
            
        }
        Group {
            HStack {
                //filter low only
                Button(action: {
                    ideals.idealLightLevelLow = "500"
                    ideals.idealLightLevelHigh = "2500"
                    tempValues[1].0 = true
                    tempValues[1].1 = false
                    tempValues[1].2 = false
                    tempValues[1].3 = false
                    
                }) {
                    //low filter
                    Text("Low")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[1].0))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[1].0), lineWidth: 2)
                        )
                }
                //filter medium only
                Button(action: {
                    ideals.idealLightLevelLow = "2500"
                    ideals.idealLightLevelHigh = "8000"
                    tempValues[1].1 = true
                    tempValues[1].0 = false
                    tempValues[1].2 = false
                    tempValues[1].3 = false
                }) {
                    //medium filter
                    Text("Medium")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[1].1))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[1].1), lineWidth: 2)
                        )
                }
                //filter high only
                Button(action: {
                    ideals.idealLightLevelLow = "8000"
                    ideals.idealLightLevelHigh = "15000"
                    tempValues[1].2 = true
                    tempValues[1].0 = false
                    tempValues[1].1 = false
                    tempValues[1].3 = false
                }) {
                    //high filter
                    Text("High")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor((setButtonColor(selected: tempValues[1].2)))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[1].2), lineWidth: 2)
                        )
                }
                //filter high only
                Button(action: {
                    tempValues[1].3 = true
                    tempValues[1].0 = false
                    tempValues[1].1 = false
                    tempValues[1].2 = false
                }) {
                    //high filter
                    Text("Custom")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor((setButtonColor(selected: tempValues[1].3)))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[1].3), lineWidth: 2)
                        )
                }
            }
        .padding(6)
        HStack {
            //text for range
            Text("Between")
                .font(.system(size: UIScreen.regTextSize))
                .frame(alignment: .center)
            //low moisture
            TextField("Low", text: $ideals.idealLightLevelLow)
                //styling
                .font(.system(size: UIScreen.regTextSize))
                .padding(6)
                .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                .border(getTextColor(bool: ideals.isLightHighGood))
                .foregroundColor(getTextColor(bool: ideals.isLightHighGood))
                .disabled(tempValues[1].3 == false)
            //seperator
            Text("-")
                //styling
                .font(.system(size: UIScreen.regTextSize)).bold()
                .frame(width: UIScreen.dashSize, height: UIScreen.textBoxHeight, alignment: .leading)
                .padding([.trailing, .leading], UIScreen.addPhotoPadding)
            //high moisture
            TextField("High", text: $ideals.idealLightLevelHigh)
                //styling
                .font(.system(size: UIScreen.regTextSize))
                .padding(6)
                .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                .border(getTextColor(bool: ideals.isLightHighGood))
                .foregroundColor(getTextColor(bool: ideals.isLightHighGood))
                .disabled(tempValues[1].3 == false)
            }
        }
        .padding(.bottom)
        HStack {
            //temperature to be entered
            Text("Temp (°F)")
                //styling
                .font(.system(size: UIScreen.regTextSize)).bold()
                .frame(width: UIScreen.idealsTextWidth, height: UIScreen.textBoxHeight, alignment: .leading)
        }
        Group {
            HStack {
                Button(action: {
                    ideals.idealTemperatureLow = "45"
                    ideals.idealTemperatureHigh = "55"
                    //filter low only
                    tempValues[2].0 = true
                    tempValues[2].1 = false
                    tempValues[2].2 = false
                    tempValues[2].3 = false
                }) {
                    //low filter
                    Text("Low")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[2].0))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[2].0), lineWidth: 2)
                        )
                }
                Button(action: {
                    ideals.idealTemperatureLow = "55"
                    ideals.idealTemperatureHigh = "70"
                    //medium filter only
                    tempValues[2].1 = true
                    tempValues[2].0 = false
                    tempValues[2].2 = false
                    tempValues[2].3 = false
                }) {
                    //medium filter
                    Text("Medium")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[2].1))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[2].1), lineWidth: 2)
                        )
                }
                Button(action: {
                    ideals.idealTemperatureLow = "70"
                    ideals.idealTemperatureHigh = "90"
                    //filter high only
                    tempValues[2].2 = true
                    tempValues[2].0 = false
                    tempValues[2].1 = false
                    tempValues[2].3 = false
                }) {
                    //high filter
                    Text("High")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[2].2))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[2].2), lineWidth: 2)
                        )
                }
                Button(action: {
                    //filter high only
                    tempValues[2].3 = true
                    tempValues[2].0 = false
                    tempValues[2].1 = false
                    tempValues[2].2 = false
                }) {
                    //high filter
                    Text("Custom")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(setButtonColor(selected: tempValues[2].3))
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(setButtonColor(selected: tempValues[2].3), lineWidth: 2)
                        )
                }
            }
        }
        .padding(6)
        HStack {
            //text for range
            Text("Between")
                .font(.system(size: UIScreen.regTextSize))
                .frame(alignment: .center)
            //low temp to be entered
            TextField("Low", text: $ideals.idealTemperatureLow)
                //styling
                .font(.system(size: UIScreen.regTextSize))
                .padding(6)
                .frame(width: UIScreen.idealsValuesWidth, height: UIScreen.idealsValuesHeight, alignment: .leading)
                .border(getTextColor(bool: ideals.isTempLowGood))
                .foregroundColor(getTextColor(bool: ideals.isTempLowGood))
                .disabled(tempValues[2].3 == false)
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
                .border(getTextColor(bool: ideals.isTempHighGood))
                .foregroundColor(getTextColor(bool: ideals.isTempHighGood))
                .disabled(tempValues[2].3 == false)
        }
        .padding(.bottom)
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
    
    /// make buttons correct color if selected
    /// - Parameters:
    ///     - selected: if the plant is selected make diff color
    ///
    /// - Returns;
    ///     - the color to be used by the button
    func setButtonColor(selected : Bool) -> Color {
        //if button is selected
        if(selected) {
            //return other color
            return Color(red: 24/255, green: 57/255, blue: 163/255)
        }
        //return regular color
        return Color.gray
    }
}

