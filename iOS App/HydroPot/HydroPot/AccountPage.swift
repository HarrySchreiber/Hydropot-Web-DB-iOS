//
//  AccountPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct AccountPage: View {
    @ObservedObject var user: GetUser
    @State var notifications = false
    @State var notToggled = true
    @State var name: String = ""
    
    var body: some View {
        GeometryReader { geomOne in
            VStack {
                NavigationView {
                    VStack {
                        VStack (alignment: .leading){
                            GeometryReader{ geometry in
                                VStack(alignment: .leading){
                                    Text("Name: ")
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    TextField(user.name, text: $name)
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.2))
                                    Text("Email: ")
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    Text(user.email)
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        .border(Color.black.opacity(0.2))

                                    Button(action: {
                                        user.logout()
                                    }) {
                                       Text("Change Password")
                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                        
                                    }
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                                    .padding(3)
                                    
                                    Button(action: {
                                        user.logout()
                                    }) {
                                       Text("Sign Out")
                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    }
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                                    .padding(3)
                                    
                                    Button(action: {
                                        user.logout()
                                    }) {
                                       Text("Toggle Notis")
                                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    }
                                    .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                    .foregroundColor(.white)
                                    .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                                    .padding(3)
                                    
                                }
                                
                            }
                            .frame(width: geomOne.size.width * 0.9, height: geomOne.size.height * 0.7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .cornerRadius(6)
                            Spacer()
                        }
                    }
                    .navigationBarTitle("Account", displayMode: .inline)
                }
            }
        }
    }
}
