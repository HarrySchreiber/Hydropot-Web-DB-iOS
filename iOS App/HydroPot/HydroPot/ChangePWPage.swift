//
//  ChangePWPage.swift
//  HydroPot
//
//  Created by David Dray on 2/10/21.
//

import SwiftUI

struct ChangePWPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @Binding var showModal: Bool
    @State private var oldPW: String = ""
    @State private var newPW: String = ""
    @State private var newConfPW: String = ""
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                VStack{
                    Text("Change Password")
                        .font(.title)
                        .foregroundColor(Color.black)
                        .padding(.top, 32)
                    Spacer()
                    HStack {
                        SecureField("Current Password", text: $oldPW)
                            .padding(6)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    .padding(.leading, geometry.size.height/30)
                    .padding(.bottom)
                    HStack {
                        SecureField("New Password", text: $newPW)
                            .padding(6)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    .padding(.leading, geometry.size.height/30)
                    .padding(.bottom)
                    HStack {
                        SecureField("Confirm New Password", text: $newConfPW)
                            .padding(6)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    .padding(.leading, geometry.size.height/30)
                    .padding(.bottom, 32)
                    
                    HStack {
                        Button(action: {
                            if ((newPW == newConfPW) && (oldPW == user.password) && (oldPW != newPW)){
                                user.changePass(password: newConfPW)
                                self.showModal.toggle()
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("Confirm")
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
                        Button(action: {
                            self.showModal.toggle()
                        }) {
                            HStack {
                                Spacer()
                                Text("Cancel")
                                Spacer()
                            }
                            .foregroundColor(Color(red: 1, green: 1, blue: 1))
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                        }
                        .frame(width: geometry.size.width * 0.88, height: geometry.size.height/12, alignment: .leading)
                        .foregroundColor(.white)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(6)
                        .padding(3)
                    }
                    .padding(.leading, geometry.size.height/30)
                    Spacer()
                }
            }
        }
    }
}
