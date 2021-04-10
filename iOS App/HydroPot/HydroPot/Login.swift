//  Login.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

/*
    view for login page
 */
struct Login: View {
    @State var selectedTab: Int = 1 //picker selections
    @State var name: String = "" //name of user
    @State var password: String = "" //password being used to login/signup
    @State var passComf: String = "" //confirmation for signup
    @State var email: String = "" //email being used to login/signup
    @StateObject var user = GetUser() //creating default user
    @State var plants = Plants() //creating default plants
    @State var loginFail = false //alert for login
    @State var signupFail = false //alert for signup
    @State var comfFail = false //alert for comf password
    
    var body: some View {
        ZStack {
            Color.white
                .onTapGesture {
                    hideKeyboard()
                }
            VStack {
                //if we are not logged in
                if (!user.loggedIn) {
                    VStack {
                        //picker view
                        Picker(selection: $selectedTab, label: Text("Picker")) {
                            //login
                            Text("Login").tag(1)
                            //signup
                            Text("Sign up").tag(2)
                        }
                        //styling
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                        //if we are trying to login
                        if (selectedTab == 1) {
                            //email stack
                            HStack {
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //password stack
                            HStack {
                                //secure field for password
                                SecureField("Password", text: $password)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //if button pressed to login
                            Button(action: {
                                //call callback and attempt to login
                                attemptLogin(email: email, password: password)
                                //if we are not on a simulator
                                if (user.deviceToken != ""){
                                    //change the device token to the current device (for notifications
                                    user.changeDeviceToken()
                                }
                            }) {
                                //title of button and styling
                                Text("Login")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(loginDisabled ? Color(red: 70/255, green: 80/255, blue: 114/255) : Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                            }
                            //if failed password
                            .alert(isPresented: $loginFail) {
                                //display the alert of an invalid login
                                Alert(title: Text(""), message: Text("Invalid Login Credentials").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Try Again").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            .disabled(loginDisabled)
                        }
                        //if we are trying to signup
                        else {
                            //stack for name
                            HStack {
                                //name field
                                TextField("Name", text: $name)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //stack for email
                            HStack {
                                //email field
                                TextField("Email", text: $email)
                                    .keyboardType(.emailAddress)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            //present alert to fill out all the fields
                            .alert(isPresented: $signupFail) {
                                Alert(title: Text(""), message: Text("This email has already been taken").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Got it!").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //stack for password
                            HStack {
                                //secure field for password
                                SecureField("Password", text: $password)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //stack for password comf
                            HStack {
                                //secure field for password comf
                                SecureField("Confirm Password", text: $passComf)
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(6)
                                    .border(Color.black.opacity(0.2))
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            //present alert if passwords don't match
                            .alert(isPresented: $comfFail) {
                                Alert(title: Text(""), message: Text("Passwords do not match").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Got it!").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            //on signup pressed
                            Button(action: {
                                //if fields are not empty
                                if (name == "" || email == "" || password == ""){
                                    //display alert saying empty fields
                                    loginFail = true
                                }
                                //if passwords do not match
                                else if (password != passComf){
                                    //display password not matching alert
                                    comfFail = true
                                }
                                //if we are good
                                else {
                                    //signup
                                    attemptSignup(name: name, email: email, password: password)
                                }
                            }) {
                                //label for button and styling
                                Text("Sign up")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(signupDisabled ? Color(red: 70/255, green: 80/255, blue: 114/255) : Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                            }
                            //present alert to fill out all the fields
                            .alert(isPresented: $loginFail) {
                                Alert(title: Text(""), message: Text("Please fill out all fields").font(.system(size: UIScreen.regTextSize)), dismissButton: .default(Text("Got it!").font(.system(size: UIScreen.regTextSize))))
                            }
                            .padding(EdgeInsets(top: 15, leading: 25, bottom: 15, trailing: 25))
                            .disabled(signupDisabled)
                        }
                    }
                    //styling
                    .frame(width: UIScreen.modalWidth, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color(UIColor(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, alpha: 0.65)))
                    .cornerRadius(6)
                }
                //if we are logged in
                else {
                    //go to home page
                    Home(user: user, plants: plants)
                }
            }
        }
        .onAppear(){
            plants.getPlantsList()
        }
    }
    
    /// callback for the login function designed to perform alert and load from db correctly
    ///
    /// - Parameters:
    ///     - email: The email of the signup attempt
    ///     - name: the name of the signup attempt
    ///     - password: The password of the signup attempt
    func attemptSignup(name: String, email: String, password: String) {
        user.signup(name: name, email: email, password: password) {
            // will be received at the login processed
            if user.loggedIn {
                //don't display alert
                signupFail = false
            }
            else{
                //do display alert
                signupFail = true
            }
        }
    }
    
    /// callback for the singup function designed to perform alert and load from db correctly
    ///
    /// - Parameters:
    ///     - email: The email of the login attempt
    ///     - password: The password of the login attempt
    func attemptLogin(email: String, password: String) {
        user.login(email: email, password: password) {
            // will be received at the login processed
            if user.loggedIn {
                //don't display alert
                loginFail = false
            }
            else{
                //do display alert
                loginFail = true
            }
        }
    }
    //Evaluates to true when the login fields are not properly formatted
    var loginDisabled: Bool {
        email.isEmpty ||
        !isValidEmail(email: email) ||
        password.isEmpty ||
        password.count < 5 ||
        !isValidPassword(password: password)
    }
    
    //Evaluates to true when the sign up fields are not properly formatted
    var signupDisabled: Bool {
        name.isEmpty ||
        email.isEmpty ||
        !isValidEmail(email: email) ||
        password.isEmpty ||
        passComf.isEmpty ||
        !isValidPassword(password: password) ||
        !isValidPassword(password: passComf)
    }
    
    /// Function to evaluate email addresses against regex's
    ///
    /// - Parameters:
    ///     - email: The email to check against the regex
    func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
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

/*
 function called (often with tap gesture) so that the keyboard hides when the user selects outside
 */
func hideKeyboard() {
     UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),to: nil, from: nil, for: nil)
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

