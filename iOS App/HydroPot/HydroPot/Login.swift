//
//  Login.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct Login: View {
    @State var selectedTab: Int = 1
    @State var name: String = ""
    @State var password: String = ""
    @State var email: String = "spencerMoney@gmail.com"
    @StateObject var user = GetUser()
    @State var plants = Plants()
    @State var alert = false
    @State var alertTwo = false
    @State var confirm: String = ""
    
    init() {
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .font: UIFont.systemFont(ofSize: UIScreen.main.bounds.size.height >  UIScreen.main.bounds.size.width ?  UIScreen.main.bounds.size.width * 0.05:  UIScreen.main.bounds.size.height * 0.05),
            ], for: .normal)
    }
    
    var body: some View {
            ZStack (){
                VStack (){
                    if (!user.loggedIn) {
                        VStack {
                            Picker(selection: $selectedTab, label: Text("Picker")) {
                                Text("Login")
                                    .tag(1)
                                Text("Sign up")
                                    .tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                            if (selectedTab == 1) {
                                HStack {
                                    TextField("Email", text: $email)
                                        .padding(3)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .border(Color.black.opacity(0.2))
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                HStack {
                                    SecureField("Password", text: $password)
                                        .padding(3)
                                        .border(Color.black.opacity(0.2))
                                        .frame(minWidth: 0, maxWidth:  UIScreen.main.bounds.size.width, minHeight: 0, maxHeight: UIScreen.main.bounds.size.height)
                                        .textFieldStyle(PlainTextFieldStyle())
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                Button(action: {
                                    attemptLogin(email: email, password: password)
                                }) {
                                   Text("Login")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                    .cornerRadius(6)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .alert(isPresented: $alert) {
                                    Alert(title: Text(""), message: Text("Invalid Login Credentials"), dismissButton: .default(Text("Try Again")))
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                            } else {
                                HStack {
                                    TextField("Name", text: $name)
                                        .padding(3)
                                        .border(Color.black.opacity(0.1))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                HStack {
                                    TextField("Email", text: $email)
                                        .padding(3)
                                        .border(Color.black.opacity(0.1))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                HStack {
                                    SecureField("Password", text: $password)
                                        .padding(3)
                                        .border(Color.black.opacity(0.1))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                HStack {
                                    SecureField("Re-enter Password", text: $confirm)
                                        .padding(3)
                                        .border(Color.black.opacity(0.1))
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                }
                                .alert(isPresented: $alertTwo) {
                                    Alert(title: Text(""), message: Text("Passwords do not match"), dismissButton: .default(Text("Got it!")))
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 5, trailing: 25))
                                Button(action: {
                                    if (name == "" || email == "" || password == ""){
                                        alert = true
                                    }
                                    else if (confirm != password){
                                        if (!(alert == true)){
                                            alertTwo = true
                                        }
                                    }
                                    else {
                                        user.signup(name: name, email: email, password: password)
                                    }
                                }) {
                                   Text("Sign up")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                    .cornerRadius(6)
                                    .frame(maxWidth: .infinity)
                                }
                                .alert(isPresented: $alert) {
                                    Alert(title: Text(""), message: Text("Please fill out all fields"), dismissButton: .default(Text("Got it!")))
                                }
                                .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            }
                        }
                        .frame(width: UIScreen.main.bounds.size.width * 0.8, height: UIScreen.main.bounds.size.height * 0.40, alignment: .center)
                        .background(Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, opacity: 0.5))
                        .cornerRadius(6)
                    } else {
                        Home(user: user, plants: plants)
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height, alignment: .center)
                .onAppear(){
                    plants.getPlantsList()
                }
            .font(.system(size:  UIScreen.main.bounds.size.height >  UIScreen.main.bounds.size.width ?  UIScreen.main.bounds.size.width * 0.05:  UIScreen.main.bounds.size.height * 0.05))
            .background(Color.white)
        }
    }
    
    func attemptLogin(email: String, password: String) {
        user.login(email: email, password: password) {
            // will be received at the login processed
            if user.loggedIn {
                alert = false
            }
            else{
                alert = true
            }
        }
    }
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
