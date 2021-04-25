//
//  ChangePWPage.swift
//  HydroPot
//
//  Created by David Dray on 2/10/21.
//

import SwiftUI

/*
 modal to change password
 */
struct ChangePWPage: View {
    @Environment(\.presentationMode) var presentationMode //pres mode to dismiss modal
    @ObservedObject var user: GetUser //get user by passing
    @Binding var showModal: Bool //toggles modal
    @State private var oldPW: String = "" //old password
    @State private var newPW: String = "" //new password
    @State private var newConfPW: String = "" //comf of password
    
    var body: some View {
        ZStack {
            Color.white
                .onTapGesture {
                    hideKeyboard()
                }
        VStack{
                VStack{
                    //change password text
                    Text("Change Password")
                        //styling
                        .font(.system(size: UIScreen.titleTextSize))
                        .foregroundColor(Color.black)
                        .padding(.top, 32)
                    Spacer()
                    HStack {
                        //secure password for user current password
                        SecureField("Current Password", text: $oldPW)
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(6)
                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    //styling
                    .padding(.leading, UIScreen.padding)
                    .padding(.bottom)
                    HStack {
                        //secure password for user new password
                        SecureField("New Password", text: $newPW)
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(6)
                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    //styling
                    .padding(.leading, UIScreen.padding)
                    .padding(.bottom)
                    HStack {
                        //confirm field for the new password
                        SecureField("Confirm New Password", text: $newConfPW)
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(6)
                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                            .border(Color.black.opacity(0.2))
                            .foregroundColor(Color.black)
                    }
                    //styling
                    .padding(.leading, UIScreen.padding)
                    .padding(.bottom, 32)
                    HStack {
                        //button submits the request
                        Button(action: {
                            //if everything checks our password wise
                            if ((newPW == newConfPW) && (oldPW == user.password) && (oldPW != newPW)){
                                //change the password db side
                                user.changePass(password: newConfPW)
                                //dismiss the modal
                                self.showModal.toggle()
                            }
                        }) {
                            HStack {
                                Spacer()
                                //confirm text
                                Text("Confirm")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                Spacer()
                            }
                            //styling
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                            .disabled(confirmPasswordDisabled)
                        }
                        //styling
                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                        .foregroundColor(.white)
                        .background(confirmPasswordDisabled ? Color(red: 70/255, green: 80/255, blue: 114/255) : Color(red: 24/255, green: 57/255, blue: 163/255))
                        .cornerRadius(6)
                        .padding(3)
                    }
                    //styling
                    .padding(.leading, UIScreen.padding)
                    HStack {
                        Button(action: {
                            //dismiss the button
                            self.showModal.toggle()
                        }) {
                            HStack {
                                Spacer()
                                //cancel text for button
                                Text("Cancel")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                Spacer()
                            }
                            //styling
                            .foregroundColor(Color(red: 1, green: 1, blue: 1))
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                        }
                        //styling
                        .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                        .foregroundColor(.white)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(6)
                        .padding(3)
                    }
                    //styling
                    .padding(.leading, UIScreen.padding)
                    Spacer()
                }
            }
        }
    }
    
    //Evaluates to true when the confirm password fields are not properly formatted
    var confirmPasswordDisabled: Bool{
        oldPW.isEmpty ||
        newPW.isEmpty ||
        newPW.count < 5 ||
        newConfPW.isEmpty ||
        !isValidPassword(password: oldPW) ||
        !isValidPassword(password: newPW) ||
        !isValidPassword(password: newConfPW) ||
        newPW != newConfPW ||
        oldPW != user.password
    }
    
    
    /// Function to evaluate passwords against regex's
    ///
    /// - Parameters:
    ///     - password: The password to check against the regex
    func isValidPassword(password: String) -> Bool{
        let passwordRegEx = "^[A-Za-z0-9!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]{5,20}$"

        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
}
