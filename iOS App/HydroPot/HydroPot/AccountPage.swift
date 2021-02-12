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
    @State var showingDetail = false
    @State var alert = false
    
    @State var noties = false {
        didSet{
            user.toggleNotifications(notifications: noties)
        }
    }
    
    
    var body: some View {
        
        let bind = Binding<Bool>(
            get:{self.noties},
            set:{self.noties = $0}
        )
        
        NavigationView {
            VStack{
                GeometryReader{ geometry in
                    VStack(){
                        HStack {
                            Text("Email: ")
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                        }
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            Text(user.email)
                                .padding(6)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                .border(Color.black.opacity(0.2))
                        }
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            Text("Name: ")
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                        }
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            TextField(user.name, text: $name).onAppear() {
                                name = user.name
                            }
                            .padding(6)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                        }
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            Button(action: {
                                if (user.name != name) {
                                    user.changeName(name: name)
                                    alert = true
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Save Name")
                                    Spacer()
                                }
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            }
                            .alert(isPresented: $alert) {
                                Alert(title: Text(""), message: Text("Username successfully changed"), dismissButton: .default(Text("Ok")))
                            }
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .foregroundColor(.white)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                            .padding(3)
                        }
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            Button(action: {
                                self.showingDetail.toggle()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Change Password")
                                    Spacer()
                                }
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                                
                            }.sheet(isPresented: $showingDetail) {
                                ChangePWPage(user: user, showModal: $showingDetail)
                            }
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .foregroundColor(.white)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                            .padding(3)
                        }
                        .padding(.leading, geometry.size.height/30)
                        
                        HStack {
                            Button(action: {
                                user.logout()
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Sign out")
                                    Spacer()
                                }
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
                        .padding(.leading, geometry.size.height/30)
                        HStack {
                            Toggle(isOn: bind) {
                                Text("Toggle Notifications")
                            }
                            .toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                            .foregroundColor(Color.black)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                        }
                        .padding(.leading, geometry.size.height/30)
                    }
                }
            }.navigationBarTitle("Account", displayMode: .inline)
        }.onAppear {
            noties = user.notifications
        }
    }
}

struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage(user: GetUser())
    }
}
