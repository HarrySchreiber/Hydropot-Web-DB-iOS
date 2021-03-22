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
    @State var ideals: Ideals = Ideals()// ideal values for pages
    @ObservedObject var pot: Pot //pot to be edited
    @Binding var showModal: Bool //toggles being dismissed
    @State var failed: Bool = false //if failed edit alert
    @State var isShowPicker: Bool = false //showing the picture picker
    @State var image: Image? = Image(systemName: "camera.circle") //default image
    @State var tempURL: String = "" //backstop for the user image
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle") //UI image to encode/decode
    @State var deletePressed = false //deleting the pot
    @State var filledSelected = "One Week" //selection for menu
    @State var isExpanded = false //if menu drops
    let filledFrequency = ["One Week", "Two Weeks", "Three Weeks", "One Month"] //the options withing the menu
    
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    ScrollView {
                        ZStack {
                            Color.white
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
                                //styling
                                .padding(.bottom)
                                HStack{
                                    //textfield to edit plant name
                                    TextField("Plant Name", text: $ideals.plantName).onAppear() {
                                        //auto fill plant name if there is one
                                        if (ideals.plantName == ""){
                                            //display plant name
                                            ideals.plantName = pot.plantName
                                        }
                                    }
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .border(Color.black.opacity(0.5))
                                }
                                //styling
                                .padding(.leading, geometry.size.height/30)
                                ZStack{
                                    //if there is not a plant already selected
                                    if (ideals.plantSelected == ""){
                                        //display that plant
                                        Text("\(pot.plantType)")
                                            //styling
                                            .font(.system(size: UIScreen.regTextSize))
                                            .foregroundColor(.black)
                                            .opacity(0.3)
                                            .padding(6)
                                            .buttonStyle(PlainButtonStyle())
                                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                            .border(Color.black.opacity(0.5))
                                    }
                                    //if there is a plant selected
                                    else {
                                        //display new plant type
                                        Text("\(ideals.plantSelected)")
                                            //styling
                                            .font(.system(size: UIScreen.regTextSize))
                                            .foregroundColor(.black)
                                            .padding(6)
                                            .buttonStyle(PlainButtonStyle())
                                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                            .border(Color.black.opacity(0.5))
                                    }
                                    
                                    //nav link to the add edit plant list to select the plant type
                                     NavigationLink(destination: AddEditPlantList(ideals: ideals, plants: plants))  {
                                        //display the cheveron to let user know to click
                                        Image(systemName: "chevron.right")
                                            //styling
                                            .foregroundColor(.black)
                                            .padding(6)
                                            .font(.system(size: UIScreen.title3TextSize))
                                            .clipShape(Circle())
                                            .padding(.leading, geometry.size.width * 0.8)
                                    }
 
                                }
                                //styling
                                .padding(.leading, geometry.size.height/30)
                                HStack {
                                    //moisture to be edited
                                    Text("Moisture (%)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                    //low moisture edit
                                    TextField("Low", text: $ideals.idealMoistureLow)
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
                                    //high moisture edit
                                    TextField("High", text: $ideals.idealMoistureHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                    
                                    
                                }
                                //styling
                                .padding(.leading, geometry.size.height/30)
                                HStack{
                                    //light to be edited
                                    Text("Light (lm)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                    //low light to be edited
                                    TextField("Low", text: $ideals.idealLightLevelLow)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                    //seperator
                                    Text("-")
                                        //padding
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
                                        .padding([.trailing, .leading], UIScreen.addPhotoPadding)
                                    //high light to be edited
                                    TextField("High", text: $ideals.idealLightLevelHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                //styling
                                .padding(.leading, geometry.size.height/30)
                                HStack {
                                    //temperature to be edited
                                    Text("Temp (°F)")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize)).bold()
                                        .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                                    //low temperature to be edited
                                    TextField("Low", text: $ideals.idealTemperatureLow)
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
                                    //high temperature to be edited
                                    TextField("High", text: $ideals.idealTemperatureHigh)
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                        .padding(6)
                                        .frame(width: geometry.size.width * 0.22, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.5))
                                }
                                //styling
                                .padding(.leading, geometry.size.height/30)
                                .padding(.bottom, 6)
                            
                                //delete button
                                Button(action: {
                                    //toggle delete alert
                                    self.deletePressed.toggle()
                                }) {
                                    HStack {
                                        //delete button text
                                        Text("Delete")
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
                                .padding()
                                .padding(.leading)
                                
                            }
                            //present image picker on toggle
                            .sheet(isPresented: $isShowPicker) {
                                //display image picker
                                ImagePicker(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
                            }
                            //styling
                            .padding(.trailing)
                            Spacer()
                        }
                    }
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
                    pot.editPlant(plantName: ideals.plantName, plantType: ideals.plantSelected, idealTempHigh: Int(ideals.idealTemperatureHigh) ?? 0, idealTempLow: Int(ideals.idealTemperatureLow) ?? 0, idealMoistureHigh: Int(ideals.idealMoistureHigh) ?? 0, idealMoistureLow:  Int(ideals.idealMoistureLow) ?? 0, idealLightHigh: Int(ideals.idealLightLevelHigh) ?? 0, idealLightLow: Int(ideals.idealLightLevelLow) ?? 0)
                    
                    //if the extension is not empty
                    if (ext != "" && tempURL != pot.image){
                        //add the encoded image
                        addImage(encodedImage: encoding, ext: ext)
                    }
                    
                    //dismiss the modal
                    self.showModal.toggle()
                }
                //if the fields are not blank and the user did change the plant type
                else if (ideals.plantName != "" && pot.plantType != "" && ideals.idealTemperatureHigh != "" && ideals.idealTemperatureLow != "" && ideals.idealMoistureHigh != "" && ideals.idealMoistureLow != "" && ideals.idealLightLevelHigh != "" && ideals.idealLightLevelLow != ""){
                    
                    //edit the plant
                    pot.editPlant(plantName: ideals.plantName, plantType: ideals.plantSelected, idealTempHigh: Int(ideals.idealTemperatureHigh) ?? 0, idealTempLow: Int(ideals.idealTemperatureLow) ?? 0, idealMoistureHigh: Int(ideals.idealMoistureHigh) ?? 0, idealMoistureLow: Int(ideals.idealMoistureLow) ?? 0, idealLightHigh: Int(ideals.idealLightLevelHigh) ?? 0, idealLightLow: Int(ideals.idealLightLevelLow) ?? 0)
                    
                    //if the extension exists
                    if (ext != "" && tempURL != pot.image){
                        //add the image
                        addImage(encodedImage: encoding, ext: ext)
                    }
                    
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
                }
            })
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
                        print("Deleting \(pot.plantName)")
                        deletePot(pot: pot)
                        //dismiss the modal
                        self.showModal.toggle()
                    },
                    //cancel button
                    secondaryButton: .cancel() {
                    }
                )
            }
            
        }.onAppear() {
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
            tempURL = pot.image
        }
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



/*
 HStack {
     //inform user what picker is for
     Text("Reminders every:")
         //styling
         .font(.system(size: UIScreen.regTextSize)).bold()
         .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
     
     //drop down menu
     DisclosureGroup("\(filledSelected)", isExpanded: $isExpanded) {
         //each option to select
         VStack {
         ForEach(filledFrequency, id: \.self) { freq in
             //display option
             Text(freq)
                 //styling
                 .font(.system(size: UIScreen.regTextSize))
                 .bold()
                 .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
                 .onTapGesture {
                     filledSelected = freq
                     withAnimation {
                         self.isExpanded.toggle()
                     }
                 }
             }
         }
     }
     //styling
     .font(.system(size: UIScreen.regTextSize))
     .padding(6)
     .frame(width: geometry.size.width * 0.52, height: geometry.size.height/12, alignment: .leading)
     .border(Color.black.opacity(0.5))
 }
 //styling
 .padding(.leading, geometry.size.height/30)
 
 Form {
     Section {
         Picker(selection: $filledSelected, label: Text("hellooo")){
             ForEach(filledFrequency, id: \.self) { freq in
                 //display option
                 Text(freq)
                     .font(.system(size: UIScreen.regTextSize))
                     .bold()
                     .frame(width: geometry.size.width * 0.325, height: geometry.size.height/12, alignment: .leading)
             }
         }
     }
 }
 
 HStack {
     Text("I would like to be reminded every: ")
         //styling
         .font(.system(size: UIScreen.regTextSize)).bold()
         .frame(width: geometry.size.width * 0.02, height: geometry.size.height/12, alignment: .leading)
         .padding([.trailing, .leading], UIScreen.addPhotoPadding)
     Menu {
         ForEach(filledFrequency, id: \.self) { freq in
             //display option
             Button("\(freq)", action: {
                 filledSelected = freq
             })
         }
    } label: {
        Label("\(filledSelected)", systemImage: "plus.circle")
    }
 }
 */
