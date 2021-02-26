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
    
    var body: some View {
        
        ZStack {
            VStack {
                if (!user.loggedIn) {
                    VStack {
                        Picker(selection: $selectedTab, label: Text("Picker")) {
                            Text("Login").tag(1)
                            Text("Sign up").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        if (selectedTab == 1) {
                            HStack {
                                TextField("Email", text: $email)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                SecureField("Password", text: $password)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            Button(action: {
                                attemptLogin(email: email, password: password)
                            }) {
                                Text("Login")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                    .cornerRadius(6)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .alert(isPresented: $alert) {
                                Alert(title: Text(""), message: Text("Invalid Login Credentials").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Try Again").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        } else {
                            HStack {
                                TextField("Name", text: $name)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                TextField("Email", text: $email)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                SecureField("Password", text: $password)
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            Button(action: {
                                if (name == "" || email == "" || password == ""){
                                    alert = true
                                }
                                else {
                                    user.signup(name: name, email: email, password: password)
                                }
                            }) {
                                Text("Sign up")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                    .cornerRadius(6)
                                    .frame(maxWidth: .infinity)
                            }
                            .alert(isPresented: $alert) {
                                Alert(title: Text(""), message: Text("Please fill out all fields").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Got it!").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                    }
                    .frame(width: UIScreen.modalWidth, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, opacity: 0.5))
                    .cornerRadius(6)
                } else {
                    Home(user: user, plants: plants)
                }
            }
        }
        .onAppear(){
            plants.getPlantsList()
        }
        .background(Color.white)
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
