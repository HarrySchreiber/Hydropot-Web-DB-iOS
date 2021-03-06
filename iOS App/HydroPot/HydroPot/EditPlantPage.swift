//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

struct EditPlantPage: View {
    @Environment(\.presentationMode) var presentationMode //to be dismissed
    @ObservedObject var user: GetUser //user that has been passed
    @ObservedObject var plants: Plants //plant list that has been passed
    @State var tempValues = [(false, false, false, false),(false, false, false, false),(false, false, false, false), (false, false, false, false)] //default
    @ObservedObject var ideals: Ideals
    @ObservedObject var pot: Pot //pot to be edited
    @Binding var showModal: Bool //toggles being dismissed
    @State var failed: Bool = false //if failed edit alert
    @State var isShowPicker: Bool = false //showing the picture picker
    @State var image: Image? = Image(systemName: "camera.circle") //default image
    @State var tempURL: String = "" //backstop for the user image
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle") //UI image to encode/decode
    @State var deletePressed = false //deleting the pot
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    ZStack {
                        Color.white
                            .onTapGesture {
                                hideKeyboard()
                            }
                        VStack{
                            HStack {
                                //button for image picker
                                Button(action: {
                                    withAnimation {
                                        //toggle the image picker
                                        self.isShowPicker.toggle()
                                    }
                                }) {
                                    VStack {
                                        //display url image
                                        if (URL(string: tempURL) != nil){
                                            VStack {
                                                //display the url image
                                                URLImage(url: URL(string: pot.image)!) { image in
                                                    image
                                                        //styling
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(alignment: .center)
                                                        .font(.system(size: UIScreen.imageSelection))
                                                        .clipShape(Circle())
                                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                        .shadow(radius: 10)
                                                }
                                                //styling
                                                .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                                                .padding(.bottom, UIScreen.addPhotoPadding)
                                                //text to tell the user to edit the photo
                                                Text("Edit Photo")
                                                    //styling
                                                    .font(.system(size: UIScreen.regTextSize))
                                                    .frame(alignment: .center)
                                            }
                                        }
                                        //if we don't have an image
                                        else {
                                            VStack {
                                                //display the default image
                                                image?
                                                    //styling
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(alignment: .center)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                    .shadow(radius: 10)
                                            }
                                            //styling
                                            .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                                            .padding(.bottom, UIScreen.addPhotoPadding)
                                            //tell the user to edit photo
                                            Text("Edit Photo")
                                                //styling
                                                .font(.system(size: UIScreen.regTextSize))
                                                .frame(alignment: .center)
                                        }
                                    }
                                    
                                }
                                //styling
                                .foregroundColor(.black)
                                .padding([.top, .leading])
                            }
                            .padding(.bottom, 3)
                            VStack (alignment: .leading) {
                                HStack{
                                    //name of the plant
                                    TextField("Plant Name", text: $ideals.plantName)
                                        //plant name
                                        .font(.system(size: UIScreen.regTextSize))
                                        .foregroundColor(.black)
                                        .padding(6)
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                .padding(.bottom, 3)
                                //show the image picker when toggled
                                .sheet(isPresented: $isShowPicker) {
                                    ImagePicker(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                                }
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
                                //if delete has been pressed/toggled
                               .alert(isPresented:$deletePressed) {
                                   Alert(
                                       //inform user about the deletion
                                       title: Text("Your plant, \(pot.plantName), is about to be deleted"),
                                       //inform big boo-boo if mistake
                                       message: Text("There is no undo"),
                                       //delete button
                                       primaryButton: .destructive(Text("Delete")) {
                                           //delete the pot
                                           deletePot(pot: pot)
                                           //dismiss the modal
                                           self.showModal.toggle()
                                       },
                                       //cancel button
                                       secondaryButton: .cancel() {
                                       }
                                   )
                               }

                                .padding(.bottom, 6)
                                idealRanges(ideals: ideals, tempValues: $tempValues)
                            
                                HStack {
                                    //delete button
                                    Button(action: {
                                        //toggle delete alert
                                        self.deletePressed.toggle()
                                    }) {
                                        HStack {
                                            //delete button text
                                            Text("Delete Pot")
                                                //styling
                                                .font(.system(size: UIScreen.regTextSize))
                                        }
                                        //styling
                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                    }
                                    //styling
                                    .foregroundColor(.white)
                                    .background(Color.red.opacity(0.8))
                                    .cornerRadius(6)
                                    .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .center)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            //nav bar stuff
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
            Button(action: {
                //toggle modal to dismiss
                self.showModal.toggle()
            }) {
                HStack {
                    //cancer text
                    Text("Cancel")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                }
            }, trailing:
            Button(action: {
                //encode image as jpeg
                let encoding = encodePictureJPEG(image: userIntefaceImage!)
                let ext = "jpeg"
                
                
                //if all the fields are not blank and the user changed the plant type
                if (ideals.plantName != "" && ideals.plantSelected != "" && ideals.idealTemperatureHigh != "" && ideals.idealTemperatureLow != "" && ideals.idealMoistureHigh != "" && ideals.idealMoistureLow != "" && ideals.idealLightLevelHigh != "" && ideals.idealLightLevelLow != ""){
                    
                    //edit pot client side
                    pot.editPlant(plantName: ideals.plantName, plantType: ideals.plantSelected, idealTempHigh: Int(ideals.idealTemperatureHigh) ?? 0, idealTempLow: Int(ideals.idealTemperatureLow) ?? 0, idealMoistureHigh: Int(ideals.idealMoistureHigh) ?? 0, idealMoistureLow:  Int(ideals.idealMoistureLow) ?? 0, idealLightHigh: Int(ideals.idealLightLevelHigh) ?? 0, idealLightLow: Int(ideals.idealLightLevelLow) ?? 0, notificationFrequency: ideals.notificationFrequency)

                    //add the encoded image and the pot or just the pot
                    addImage(encodedImage: encoding, ext: ext)
  
                    
                    //dismiss the modal
                    self.showModal.toggle()
                }
                //if the fields are not blank and the user did change the plant type
                else if (ideals.plantName != "" && pot.plantType != "" && ideals.idealTemperatureHigh != "" && ideals.idealTemperatureLow != "" && ideals.idealMoistureHigh != "" && ideals.idealMoistureLow != "" && ideals.idealLightLevelHigh != "" && ideals.idealLightLevelLow != ""){
                    
                    //edit the plant
                    pot.editPlant(plantName: ideals.plantName, plantType: ideals.plantSelected, idealTempHigh: Int(ideals.idealTemperatureHigh) ?? 0, idealTempLow: Int(ideals.idealTemperatureLow) ?? 0, idealMoistureHigh: Int(ideals.idealMoistureHigh) ?? 0, idealMoistureLow: Int(ideals.idealMoistureLow) ?? 0, idealLightHigh: Int(ideals.idealLightLevelHigh) ?? 0, idealLightLow: Int(ideals.idealLightLevelLow) ?? 0, notificationFrequency: ideals.notificationFrequency)


                    //add the image and the pot or just the pot
                    addImage(encodedImage: encoding, ext: ext)
   
                    
                    //dismiss the modal
                    self.showModal.toggle()
                    
                    }
                else {
                    //tell the user to fill all fields
                    failed = true
                }
            }) {
                HStack {
                    //confirm button
                    Text("Confirm")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .foregroundColor(confirmDisabled ? .gray : .white)
                }
            }
            .disabled(confirmDisabled))
            //if the edit has failed
            .alert(isPresented: $failed) {
                //inform user why
                Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
            }
            //if delete has been pressed/toggled
            .alert(isPresented:$deletePressed) {
                Alert(
                    //inform user about the deletion
                    title: Text("Your plant, \(pot.plantName), is about to be deleted"),
                    //inform big boo-boo if mistake
                    message: Text("There is no undo"),
                    //delete button
                    primaryButton: .destructive(Text("Delete")) {
                        //delete the pot
                        deletePot(pot: pot)
                        //dismiss the modal
                        self.showModal.toggle()
                    },
                    //cancel button
                    secondaryButton: .cancel() {
                    }
                )
            }
            
        }
        .onAppear() {
            //what plant type the user has selected
            ideals.plantSelected = pot.plantType
            //stringify the moisture low
            ideals.idealMoistureLow = String(pot.idealMoistureLow)
            //stringify the moisture high
            ideals.idealMoistureHigh = String(pot.idealMoistureHigh)
            //stringify the temperature low
            ideals.idealTemperatureLow = String(pot.idealTempLow)
            //stringify the temperature high
            ideals.idealTemperatureHigh = String(pot.idealTempHigh)
            //stringify the light low
            ideals.idealLightLevelLow = String(pot.idealLightLow)
            //stringify the light high
            ideals.idealLightLevelHigh = String(pot.idealLightHigh)
            //if we have selected an image
            if (tempURL == ""){
                tempURL = pot.image
            }
            
            //handling no ideal moist low
            if (ideals.idealMoistureLow == "-1000"){
                ideals.idealMoistureLow = ""
            }
            //handling no ideal moist high
            if (ideals.idealMoistureHigh == "-1000"){
                ideals.idealMoistureHigh = ""
            }
            //handling no ideal temp low
            if (ideals.idealTemperatureLow == "-1000"){
                ideals.idealTemperatureLow = ""
            }
            //handling no ideal temp high
            if (ideals.idealTemperatureHigh == "-1000"){
                ideals.idealTemperatureHigh = ""
            }
            //handling no ideal light low
            if (ideals.idealLightLevelLow == "-1000"){
                ideals.idealLightLevelLow = ""
            }
            //handling no ideal light high
            if (ideals.idealLightLevelHigh == "-1000"){
                ideals.idealLightLevelHigh = ""
            }
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
    
    /// encodes the image as a jpeg
    ///
    /// - Parameters:
    ///     - image: the ui image to encode
    ///
    /// - Returns:
    ///     - the encoded image as a jpeg
    func encodePictureJPEG (image: UIImage) -> String{
        
        guard let imageData = image.jpeg(UIImage.JPEGQuality(rawValue: 0)!) else {
            return ""
        }
        
        return imageData.base64EncodedString()
        
    }

   /// deleting a pot on the db side and client side
   ///
   /// - Parameters:
   ///     - pot: pot to be deleted
   func deletePot(pot: Pot) {
       //for each pot
       for i in 0...user.pots.count {
           //if we found our pot
           if (user.pots[i].id == pot.id) {
               //delete the pot
               user.deletePot(Index: i)
               break
           }
       }
   }
    
    /// add image to the database
    ///
    /// - Parameters:
    ///     - encodedImage: the encoding of the image
    ///     - ext: the extension of the image
    func addImage(encodedImage: String, ext: String) {
        
        //if we do have image
        if (tempURL != pot.image){
            //upload image
            user.uploadImage(encoding: encodedImage, ext: ext, pot: pot) {
                if user.loggedIn {
                    //edit the pot
                    user.editPot(pot: pot)
                }
            }
        }
        //if we don't have an image
        else {
            if user.loggedIn {
                //edit the pot
                user.editPot(pot: pot)
            }
        }
    }
    
    //Evaluates to true when the edit fields are not properly formatted
    var confirmDisabled: Bool{
        ideals.plantName.isEmpty ||
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
    image picker for the add/edit pages
 */
struct ImagePicker: UIViewControllerRepresentable {
    
    
    @Environment(\.presentationMode)
    var presentationMode //presentation of the image picker
    
    @Binding var image: Image? //image
    @Binding var tempURL: String //url for default
    @Binding var userIntefaceImage: UIImage? //ui Image to encode/decode
    
    /*
        how the picker gets its' images
     */
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        @Binding var presentationMode: PresentationMode //dismiss
        @Binding var image: Image? //image to be picked
        @Binding var tempURL: String //temp to know if selected
        @Binding var userIntefaceImage: UIImage? //ui image to pass back

        /// constructor for the image picker
        ///
        /// - Parameters:
        ///     - presentationMode: what dismisses the picker
        ///     - image: the raw image
        ///     - tempURL: the way the user knows if an image was selected
        ///     - userInterfaceImage: The UI image to be encoded/decoded
        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, tempURL: Binding<String>, userIntefaceImage: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
            _tempURL = tempURL
            _userIntefaceImage = userIntefaceImage
        }
        
        /*
            controller stuff
         */
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if let imageData = uiImage.jpeg(UIImage.JPEGQuality(rawValue: 0)!) {
                let otherImage = UIImage(data: imageData) //keep ui image
                image = Image(uiImage: otherImage!) //regular image
                tempURL = "not empty" //user stuff
                userIntefaceImage = otherImage //save the UI image to be passed back
            }
            //dismiss the modal
            presentationMode.dismiss()
            
        }
        
        /*
            if cancelled is pressed
         */
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //dismiss the modal
            presentationMode.dismiss()
        }
        
    }
    
    /*
        on the init create the controller
     */
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, tempURL: $tempURL, userIntefaceImage: $userIntefaceImage)
    }
    
    /*
        make the picker controlled
     */
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    /*
        update the controller
     */
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
}
