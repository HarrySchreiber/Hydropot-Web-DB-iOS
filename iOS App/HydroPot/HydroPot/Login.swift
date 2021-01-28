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
    @State var password: String = "Failure"
    @State var email: String = "Example@example.com"
    @StateObject var user = GetUser()
    
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
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .fixedSize()
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                TextField("Password", text: $password)
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .fixedSize()
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            Button(action: {
                                user.login(email: email, password: password)
                            }) {
                               Text("Login")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                .cornerRadius(6)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        } else {
                            HStack {
                                TextField("Name", text: $name)
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                TextField("Email", text: $email)
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            HStack {
                                TextField("Password", text: $password)
                                    .fixedSize()
                                    .padding(6)
                                    .border(Color.black.opacity(0.1))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            Button(action: {
                                user.signup(userId: UUID().uuidString, name: name, email: email, password: password)
                                user.loggedIn = true
                            }) {
                               Text("Sign up")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                                .cornerRadius(6)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        }
                    }
                    .frame(width: 280, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color(red: 0.090, green: 0.607, blue: 0.839, opacity: 0.1))
                    .cornerRadius(6)
                } else {
                    Home(user: user)
                }
            }
        }
        .background(Color.white)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
