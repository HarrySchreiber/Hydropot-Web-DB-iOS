//
//  AddPlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

struct EditPlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    @ObservedObject var pot: Pot
    @Binding var showModal: Bool
    @Binding var moistureGood: Bool
    @Binding var lightGood: Bool
    @Binding var tempGood: Bool
    @Binding var resGood: Bool
    @State var plantName = ""
    @State var plantType = ""
    @State var idealTemperatureHigh: String = ""
    @State var idealMoistureHigh: String = ""
    @State var idealLightLevelHigh: String = ""
    @State var idealTemperatureLow: String = ""
    @State var idealMoistureLow: String = ""
    @State var idealLightLevelLow: String = ""
    @State var plantSelected: String = ""
    @State var failed: Bool = false
    @State var isShowPicker: Bool = false
    @State var image: Image? = Image(systemName: "camera.circle")
    @State var tempURL: String = ""
    @State var userIntefaceImage: UIImage? = UIImage(systemName: "camera.circle")

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
                            if (URL(string: tempURL) != nil){
                                if (URL(string: pot.image) != nil){
                                    URLImage(url: URL(string: pot.image)!) { image in
                                        VStack {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(alignment: .center)
                                                .font(.system(size: UIScreen.imageSelection))
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                .shadow(radius: 10)
                                        }
                                        .frame(width: UIScreen.imageSelection, height:  UIScreen.imageSelection)
                                    }
                                }
                                else {
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: UIScreen.homeImageSize))
                                }
                            }
                            else {
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
                            
                        }
                        .foregroundColor(.black)
                            .frame(alignment: .center)
                            .padding(.bottom, 3)
                        Text("Edit Photo")
                            .font(.system(size: UIScreen.regTextSize))
                            .frame(alignment: .center)
                            .padding(.bottom, 3)
                        HStack{
                            TextField("Plant Name", text: $plantName).onAppear() {
                                if (plantName == ""){
                                    plantName = pot.plantName
                                }
                            }
                                .padding(6)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.5))
                        }
                            .padding(.leading, geometry.size.height/30)
                        ZStack{
                            if (plantSelected == ""){
                                Text("\(pot.plantType)")
                                    .foregroundColor(.black)
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
                    .sheet(isPresented: $isShowPicker) {
                        ImagePickerTwo(image: self.$image, tempURL: self.$tempURL, userIntefaceImage: self.$userIntefaceImage)
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
                            .font(.system(size: UIScreen.regTextSize))
                    }
            }, trailing:
                Button(action: {
                    
                    var encoding = encodePicturePNG(image: userIntefaceImage!)
                    var ext = ""
                    
                    if (encoding == ""){
                        encoding = encodePictureJPEG(image: userIntefaceImage!)
                        ext = "jpeg"
                    }
                    else {
                        ext = "png"
                    }
                    if (plantName != "" && plantSelected != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        pot.editPlant(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0)
                        
                        if (ext != ""){
                            addImage(encodedImage: encoding, ext: ext)
                        }
                        
                        self.showModal.toggle()
                    }
                    else if (plantName != "" && pot.plantType != "" && idealTemperatureHigh != "" && idealTemperatureLow != "" && idealMoistureHigh != "" && idealMoistureLow != "" && idealLightLevelHigh != "" && idealLightLevelLow != ""){
                        pot.editPlant(plantName: plantName, plantType: plantSelected, idealTempHigh: Int(idealTemperatureHigh) ?? 0, idealTempLow: Int(idealTemperatureLow) ?? 0, idealMoistureHigh: Int(idealMoistureHigh) ?? 0, idealMoistureLow: Int(idealMoistureLow) ?? 0, idealLightHigh: Int(idealLightLevelHigh) ?? 0, idealLightLow: Int(idealLightLevelLow) ?? 0)
                        
                        if (ext != ""){
                            addImage(encodedImage: encoding, ext: ext)
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
            })
            .alert(isPresented: $failed) {
                Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
            }

        }.onAppear() {
            plantSelected = pot.plantType
            idealMoistureLow = String(pot.idealMoistureLow)
            idealMoistureHigh = String(pot.idealMoistureHigh)
            idealTemperatureLow = String(pot.idealTempLow)
            idealTemperatureHigh = String(pot.idealTempHigh)
            idealLightLevelLow = String(pot.idealLightLow)
            idealLightLevelHigh = String(pot.idealLightHigh)
            tempURL = pot.image
        }
        .onDisappear() {
            moistureGood = ((pot.curMoisture >= pot.idealMoistureLow) && (pot.curMoisture <= pot.idealMoistureHigh))
            lightGood = (pot.curLight >= pot.idealLightLow && pot.curLight <= pot.idealLightHigh)
            tempGood = (pot.curTemp >= pot.idealTempLow && pot.curTemp <= pot.idealTempHigh)
            resGood = pot.resLevel > 20
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


    
    func addImage(encodedImage: String, ext: String) {
        
        user.uploadImage(encoding: encodedImage, ext: ext, pot: pot) {
            if user.loggedIn {
                print(pot.image)
                user.editPot(pot: pot)
            }
        }
    }
}


struct ImagePickerTwo: UIViewControllerRepresentable {
    

    @Environment(\.presentationMode)
    var presentationMode

    @Binding var image: Image?
    @Binding var tempURL: String
    @Binding var userIntefaceImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var tempURL: String
        @Binding var userIntefaceImage: UIImage?

        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, tempURL: Binding<String>, userIntefaceImage: Binding<UIImage?>) {
            _presentationMode = presentationMode
            _image = image
            _tempURL = tempURL
            _userIntefaceImage = userIntefaceImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            image = Image(uiImage: uiImage)
            tempURL = ""
            userIntefaceImage = uiImage
            presentationMode.dismiss()

        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode, image: $image, tempURL: $tempURL, userIntefaceImage: $userIntefaceImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerTwo>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerTwo>) {

    }

}
