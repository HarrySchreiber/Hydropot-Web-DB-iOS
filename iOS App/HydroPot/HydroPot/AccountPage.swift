//
//  AccountPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
/*
 page to change account information
 */
struct AccountPage: View {
    @ObservedObject var user: GetUser //user passed from other views
    @State var notToggled = true //
    @State var name: String = "" // name of user
    @State var showingDetail = false //showing the password change modal
    @State var alert = false //alert if empty
    
    //notifications toggled
    @State var noties = false {
        didSet{
            //toggle db side
            user.toggleNotifications(notifications: noties)
        }
    }
    
    
    var body: some View {
        
        //binding for notis
        let bind = Binding<Bool>(
            get:{self.noties},
            set:{self.noties = $0}
        )
        
        NavigationView {
            ZStack {
                Color.white
                    .onTapGesture {
                        hideKeyboard()
                    }
                VStack{
                    GeometryReader{ geometry in
                        VStack(){
                            HStack {
                                //email for user to see
                                Text("Email: ")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .frame(width: UIScreen.textSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                //email displayed to user
                                Text(user.email)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .frame(width: UIScreen.loginTextBoxSize, height: UIScreen.textBoxHeight, alignment: .leading)
                            }
                            //styling
                            .padding(.leading, 6)
                            .padding(.bottom, 6)
                            HStack {
                                //name for user to know to edit
                                Text("Name: ")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .frame(width: UIScreen.textSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                //field for user to edit name
                                TextField(user.name, text: $name).onAppear() {
                                    name = user.name
                                }
                                //styling
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(6)
                                .frame(width: UIScreen.loginTextBoxSize, height: UIScreen.textBoxHeight, alignment: .leading)
                                .border(Color.black.opacity(0.2))
                            }
                            //styling
                            .padding(.leading, 6)
                            .padding(.bottom, 6)
                            HStack {
                                //button to submit name
                                Button(action: {
                                    //if name is not same
                                    if (user.name != name) {
                                        //change name db
                                        user.changeName(name: name)
                                        //display alert to notify user
                                        alert = true
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        //save name button
                                        Text("Save Name")
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
                                //present alert that name was changed
                                .alert(isPresented: $alert) {
                                    Alert(title: Text(""), message: Text("Username successfully changed")                            .font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Ok")                            .font(.system(size: UIScreen.regTextSize))))
                                }
                                //styling
                                .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                .foregroundColor(.white)
                                .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                .cornerRadius(6)
                                .padding(3)
                            }
                            //styling
                            .padding(.leading, 6)
                            HStack {
                                //button to change password
                                Button(action: {
                                    //toggle button to display modal
                                    self.showingDetail.toggle()
                                }) {
                                    HStack {
                                        Spacer()
                                        //change password display on button
                                        Text("Change Password")
                                            //styling
                                            .font(.system(size: UIScreen.regTextSize))
                                        Spacer()
                                    }
                                    //styling
                                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                                    .multilineTextAlignment(.center)
                                    .padding(10)
                                    .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                    //presenting the password modal
                                }.sheet(isPresented: $showingDetail) {
                                    ChangePWPage(user: user, showModal: $showingDetail)
                                }
                                //styling
                                .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                                .foregroundColor(.white)
                                .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                .cornerRadius(6)
                                .padding(3)
                            }
                            //styling
                            .padding(.leading, 6)
                            HStack {
                                //button to let user logout
                                Button(action: {
                                    //logout
                                    user.logout()
                                }) {
                                    HStack {
                                        Spacer()
                                        //sign out text
                                        Text("Sign out")
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
                                .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                .cornerRadius(6)
                                .padding(3)
                            }
                            //styling
                            .padding(.leading, 6)
                            HStack {
                                //toggle for notis
                                Toggle(isOn: bind) {
                                    //label for toggle
                                    Text("Toggle Notifications")
                                        //styling
                                        .font(.system(size: UIScreen.regTextSize))
                                }
                                //styling
                                .toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .frame(width: UIScreen.textBoxWidth, height: UIScreen.textBoxHeight, alignment: .leading)
                            }
                            //styling
                            .padding(.leading, 6)
                        }
                    }
                }
                .padding(.top, 100)
                .padding(.leading, 12)
                .navigationBarTitle("Account", displayMode: .inline)
            }
        }.onAppear {
            //set to user notis actually
            noties = user.notifications
        }
    }
    
    //Evaluates to true when the name field is not properly formatted
    var saveNameDisabled: Bool{
        name.isEmpty
    }
}

/*
 preview for sim
 */
struct AccountPage_Previews: PreviewProvider {
    static var previews: some View {
        AccountPage(user: GetUser())
    }
}
