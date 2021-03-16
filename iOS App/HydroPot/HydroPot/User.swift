//
//  User.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/27/21.
//

import Foundation

/*
    Codable to hold results from aws api call
 */
struct UserResults: Codable {
    let Items: [User] //items/users returned
    let Count: Int //num items returned
    let ScannedCount: Int //num scanned
}

/*
    Codable to convert user json into struct to place in class
 */
struct User: Codable, Identifiable {
    let id: String //user id
    let email: String //email of user
    let hashedPW: String //hashed password of the user
    let userName: String //username of the user
    let notifications: Bool //is notifications on
    let deviceToken: String //device token on device registered
    let pots: [codePot]? //pots the user has
    
    //conform to codable
    enum CodingKeys: String, CodingKey {
        case id, email, hashedPW, userName, pots, notifications, deviceToken
    }
}

/*
    User object to store users
 */
class GetUser: ObservableObject {
    @Published var userId: String //id of the user
    @Published var loggedIn: Bool //is the user logged in
    @Published var name: String //name of the user
    @Published var email: String //email of the user
    @Published var password: String //password of the user
    @Published var notifications: Bool //does the user want notifications
    @Published var deviceToken: String //current device token
    @Published var pots: [Pot] //pots the user owns

    /// Constructor for user
    ///
    /// - Parameters:
    ///     - userID: Id of the user
    ///     - loggedIn: Is the user logged in
    ///     - name: Name of the user
    ///     - email: Email of the user
    ///     - password: Password of the user
    ///     - pots: Pots the owns
    ///     - notifications: Does the user want notifications
    ///     - deviceToken: Device token of current device
    init() {
        self.userId = ""
        self.loggedIn = false
        self.name = "Spencer The Cool"
        self.email = ""
        self.password = ""
        self.pots = []
        self.notifications = true
        self.deviceToken =   UserDefaults.standard.string(forKey: "deviceToken") ?? ""
    }
    
    /// Login function for loading up everything and checking credentials
    ///
    /// - Parameters:
    ///     - email: Email of the user
    ///     - password: Password of the user
    ///     - onEnded: Callback to function
    func login (email: String, password: String, onEnded: @escaping () -> ()) {
        
        //payload to send to aws
        let json: [String: Any] =
            ["operation": "login", "tableName": "HydroPotUsers", "payload": ["Item": ["email": email, "password": password]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //access url for lambda
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //we are posting
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        //acept results
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        // start a data task to download the data from the URL
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            // decode the returned data to codable
            let results: UserResults?
            do {
                //decoding the data
                let decoder = JSONDecoder()
                //try to decode into our codable
                results = try decoder.decode(UserResults.self, from: d)
            } catch {
                //if we failed
                results = nil
            }
            //if we could not decode
            guard let r = results else {
                //not able to decode
                print("Unable to parse user login JSON")
                return
            }
            //execute asynch function
            DispatchQueue.main.async(execute: {
                //ouw pots are empty (prevent spam)
                self.pots = []
                //if we have a user
                if ((r.Items.count) != 0) {
                    self.userId = r.Items[0].id //set it
                    self.loggedIn = true //set logged in
                    self.name = r.Items[0].userName //set username
                    self.email = r.Items[0].email //set email
                    self.password = password //set password
                    self.notifications = r.Items[0].notifications //set notifications
                    let codePots = r.Items[0].pots //set pots
                    //if we have pots
                    if (codePots?.count != 0){
                        //for every pot
                        for pot in codePots! {
                            //establish records as empty
                            var records : [Record] = []
                            //for every record
                            for rec in pot.records! {
                                //format date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                //make record
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir, watering: rec.watering)
                                //append record
                                records.append(record)
                            }
                            //establish notifications as empty
                            var notifications : [Notification] = []
                            //for every noti
                            for notie in pot.notifications! {
                                //format date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: notie.timeStamp)
                                
                                //make notification
                                let notification = Notification(type: notie.type, timeStamp: date ?? Date())
                                //append noti
                                notifications.append(notification)
                            }
                            
                            //last watered is today if we don't have any records
                            var lastWatered = Date()
                            
                            //if we have records
                            if (records.count != 0){
                                //looking for last watered
                                for rec in records.reversed() {
                                    //if we have watered
                                    if (rec.watering != 0){
                                        //establish last watered
                                        lastWatered = rec.dateRecorded
                                        break
                                    }
                                }
                                //append the newly created pot with our record
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, resLevel: records[records.count-1].reservoir, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id))
                            }
                            //if we don't have a record create this pot
                            else {
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: Date(), records: records, notifications: notifications, resLevel: 0, curTemp: 0, curLight: 0, curMoisture: 0, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id))
                            }
                        }
                    }
                    
                    //permanent login for leaving app
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                }
                //return to callback
                onEnded()
            })
        }.resume()
    }
    
    /// Reload function to reload data from aws
    ///
    /// - Parameters:
    ///     - onEnded: Callback to function
    func reload (onEnded: @escaping () -> ()) {

        let json: [String: Any] =
            ["operation": "login", "tableName": "HydroPotUsers", "payload": ["Item": ["email": email, "password": password]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //access url for lambda
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //we are posting
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        //acept results
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        // start a data task to download the data from the URL
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            // decode the returned data to codable
            let results: UserResults?
            do {
                //decoding the data
                let decoder = JSONDecoder()
                //try to decode into our codable
                results = try decoder.decode(UserResults.self, from: d)
            } catch {
                //if we failed
                results = nil
            }
            //if we could not decode
            guard let r = results else {
                //not able to decode
                print("Unable to parse user login JSON")
                return
            }
            //execute asynch function
            DispatchQueue.main.async(execute: {
                //ouw pots are empty (prevent spam)
                self.pots = []
                //if we have a user
                if ((r.Items.count) != 0) {
                    self.userId = r.Items[0].id //set it
                    self.loggedIn = true //set logged in
                    self.name = r.Items[0].userName //set username
                    self.email = r.Items[0].email //set email
                    self.notifications = r.Items[0].notifications //set notifications
                    let codePots = r.Items[0].pots //set pots
                    //if we have pots
                    if (codePots?.count != 0){
                        //for every pot
                        for pot in codePots! {
                            //establish records as empty
                            var records : [Record] = []
                            //for every record
                            for rec in pot.records! {
                                //format date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                //make record
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir, watering: rec.watering)
                                //append record
                                records.append(record)
                            }
                            //establish notifications as empty
                            var notifications : [Notification] = []
                            //for every noti
                            for notie in pot.notifications! {
                                //format date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: notie.timeStamp)
                                
                                //make notification
                                let notification = Notification(type: notie.type, timeStamp: date ?? Date())
                                //append noti
                                notifications.append(notification)
                            }
                            
                            //last watered is today if we don't have any records
                            var lastWatered = Date()
                            
                            //if we have records
                            if (records.count != 0){
                                //looking for last watered
                                for rec in records.reversed() {
                                    //if we have watered
                                    if (rec.watering != 0){
                                        //establish last watered
                                        lastWatered = rec.dateRecorded
                                        break
                                    }
                                }
                                //append the newly created pot with our record
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, resLevel: records[records.count-1].reservoir, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id))
                            }
                            //if we don't have a record create this pot
                            else {
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: Date(), records: records, notifications: notifications, resLevel: 0, curTemp: 0, curLight: 0, curMoisture: 0, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id))
                            }
                        }
                    }
                    
                    //permanent login for leaving app
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                }
                //return to callback
                onEnded()
            })
        }.resume()
    }
    
 
    /// Logout function to reset the user
    func logout() {
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
    }
    
    /// Signing up the user to aws
    ///
    /// - Parameters:
    ///     - name: Name of the user
    ///     - email: Email of the user
    ///     - password: Password of the user
    func signup(name: String, email: String, password: String) {
        
        //create the users ID
        let tempID = UUID()
        
        //create payload for aws lambda
        let json: [String: Any] = ["operation": "signup", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": email, "password": password, "id": tempID.uuidString, "notifications": notifications, "deviceToken": deviceToken]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //url to send to lambda
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //create request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        //start session/data
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in }.resume()
        
        self.userId = tempID.uuidString //user id
        self.loggedIn = true //logged in
        self.name = name //user name
        self.email = email //user email
        self.password = password //user password
        self.pots = [] //user has no pots

    }
    
    /// Adding pot to user through aws
    ///
    /// - Parameters:
    ///     - pot: The user's pot to be added
    func addPlant(pot: Pot) {
        
        //date formatter for various dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        //append the pot client side
        pots.append(pot)

        //payload to send to aws lambda
        let json: [String: Any] =
            [
              "operation": "addPots",
              "tableName": "HydroPotUsers",
              "payload": [
                "Item": [
                    "id": userId,
                    "email": email,
                  "pot": [
                    "automaticWatering": pot.automaticWatering,
                    "id": pot.id,
                    "idealLightHigh": pot.idealLightHigh,
                    "idealLightLow": pot.idealTempLow,
                    "idealMoistureHigh": pot.idealMoistureHigh,
                    "idealMoistureLow": pot.idealMoistureLow,
                    "idealTempHigh": pot.idealTempHigh,
                    "idealTempLow": pot.idealTempLow,
                    "image": pot.image,
                    "notifications": [],
                    "plantName": pot.plantName,
                    "plantType": pot.plantType,
                    "records": []
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //url to send to aws
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //config and start session
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in}.resume()
    }
    
    /// replacing the pot client side
    ///
    /// - Parameters:
    ///     - pot: the user's pot to be replaced
    func replacePot(pot: Pot){
        //for all our pots
        for (index, _) in pots.enumerated() {
            //if we find the pot to be replaced
            if (self.pots[index].id == pot.id){
                //replaced with new pot
                self.pots[index] = pot
            }
        }
    }
    
    
    /// deleting a pot at a given index
    ///
    /// - Parameters:
    ///     - index: the index to delete the pot
    func deletePot(Index: Int){

        //payload to send to aws
        let json: [String: Any] =
            [
              "operation": "deletePot",
              "tableName": "HydroPotUsers",
              "payload": [
                "Item": [
                    "id": userId,
                    "email": email,
                  "pot": [
                    "id": pots[Index].id,
                  ]
                ]
              ]
            ]
        
        //remove the pot client side
        pots.remove(at: Index)
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //where we are sending it to
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //posting request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        //config the session
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error resposne
        session.dataTask(with: request) { data, response, error in}.resume()
        
    }
    
    /// editing a pot
    ///
    /// - Parameters:
    ///     - pot: the pot to be edited
    func editPot(pot: Pot){
        
        //replace the pot client side with our new one
        replacePot(pot: pot)
                
        //format our date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        //making array for notis json
        var notieJsonArray : [Dictionary<String, Any>] = []

        //for every noti
        for notification in pot.notifications {
            //make noti dict
            var notieDict : [String: String] = [:]
            //format timestamp
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            //our values
            notieDict["timeStamp"] = dateString
            notieDict["type"] = notification.type
            
            //append json to noti array
            notieJsonArray.append(notieDict)
        }
        
        //records json array
        var recJsonArray : [Dictionary<String, Any>] = []
        //for each record
        for record in pot.records {
            //make new records dict
            var recDict : [String: Any] = [:]
            //for date on record
            let dateString = dateFormatter.string(from: record.dateRecorded)
            
            //values for the records
            recDict["dateRecorded"] = dateString //date recorded
            recDict["light"] = record.light //light of record
            recDict["moisture"] = record.moisture //moisture of record
            recDict["reservoir"] = record.reservoir //res level of record
            recDict["temperature"] = record.temperature //temperature of record
            recDict["watering"] = record.watering //watering of record
            
            //append our single record
            recJsonArray.append(recDict)
        }
        //json payload to submit
        let json: [String: Any] =
            [
              "operation": "editPot",
              "tableName": "HydroPotUsers",
              "payload": [
                "Item": [
                    "id": userId,
                    "email": email,
                  "pot": [
                    "automaticWatering": pot.automaticWatering,
                    "id": pot.id,
                    "idealLightHigh": pot.idealLightHigh,
                    "idealLightLow": pot.idealLightLow,
                    "idealMoistureHigh": pot.idealMoistureHigh,
                    "idealMoistureLow": pot.idealMoistureLow,
                    "idealTempHigh": pot.idealTempHigh,
                    "idealTempLow": pot.idealTempLow,
                    "image": pot.image,
                    "notifications": notieJsonArray,
                    "plantName": pot.plantName,
                    "plantType": pot.plantType,
                    "records": recJsonArray
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //url to send to aws
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        //config request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in}.resume()
        
    }
    
    
    /// getting notifications in correct date ordering
    ///
    /// - Returns:
    ///     - array of notiePots
    func getOrderedNotifications() ->  [notiePots] {
        //make list of tuples, pot : notification
        //for each pot, add notification
        var notiesTupleList : [notiePots] = []
        var counter = 0
        for pot in pots {
            for notie in pot.notifications {
                counter += 1
                let notiePot = notiePots(id: counter, notiesTuple: (pot, notie))
                notiesTupleList.append(notiePot)
            }
        }
        //sort list of tuples
        notiesTupleList = notiesTupleList.sorted(by: {
            $0.notiesTuple.notification.timeStamp.compare($1.notiesTuple.notification.timeStamp) == .orderedDescending
        })
        //return
        return notiesTupleList
        
    }
    
    /// changing password client and server side
    ///
    /// - Parameters:
    ///     - password: the password to be changed
    func changePass(password: String) {
        
        //update pasword client side
        self.password = password
        
        //payload to send to aws
        let json: [String: Any] = ["operation": "changePass", "tableName": "HydroPotUsers", "payload": ["Item": ["name": self.name, "email": self.email, "password": password, "id": self.userId]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //url to send request to
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure and submit request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    /// changing username client and server side
    ///
    /// - Parameters:
    ///     - name: the name to be changed
    func changeName(name: String) {
        
        //change name client side
        self.name = name
        
        //payload to send to aws lambda
        let json: [String: Any] = ["operation": "changeName", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": self.email, "password": password, "id": self.userId]]]
        
        //jsonify the payload
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //the url we are sending the request to
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure and submit request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in }.resume()
    }
    
    /// changing device token server side
    ///
    func changeDeviceToken() {
                
        //payload to send to aws lambda
        let json: [String: Any] = ["operation": "changeName", "tableName": "HydroPotUsers", "payload": ["Item": ["email": self.email, "id": self.userId, "deviceToken": self.deviceToken]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //the url to submit the request
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure and submit the request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    /// changing whether the user wants notifications
    ///
    /// - Parameters:
    ///     - notifications: whether the user wants notifications or not
    func toggleNotifications(notifications: Bool) {
        
        //change client side
        self.notifications = notifications
        
        //json payload to send to aws lambda
        let json: [String: Any] = ["operation": "toggleNotis", "tableName": "HydroPotUsers", "payload": ["Item": ["name": self.name, "email": self.email, "notifications": notifications, "id": self.userId]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //url to send to aws lambda
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure and submit the request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    /// water the pot server side
    ///
    /// - Parameters:
    ///     - pot: the pot to be watered
    ///     - waterAmount: the amount to water the pot
    func waterPot(pot: Pot, waterAmount: Int){
        
        //replace the pot with the new request server side
        replacePot(pot: pot)
        
        //if we have records then update the last record to let pot know
        if (pot.records.count != 0){
            pot.records[pot.records.count-1].watering = waterAmount
            pot.records[pot.records.count-1].dateRecorded = Date()
            pot.lastWatered = Date()
        }
        //if we don't have records then we create a dummy record for the pot to know we want to water
        else {
            pot.records.append(Record(dateRecorded: Date(), moisture: 0, temperature: 0, light: 0, reservoir: 0, watering: waterAmount))
        }
                
       //format for dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        
        //making array for notis json
        var notieJsonArray : [Dictionary<String, Any>] = []

        //for every noti
        for notification in pot.notifications {
            //make noti dict
            var notieDict : [String: String] = [:]
            //format timestamp
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            //our values
            notieDict["timeStamp"] = dateString
            notieDict["type"] = notification.type
            
            //append json to noti array
            notieJsonArray.append(notieDict)
        }
        
        //records json array
        var recJsonArray : [Dictionary<String, Any>] = []
        //for each record
        for record in pot.records {
            //make new records dict
            var recDict : [String: Any] = [:]
            //for date on record
            let dateString = dateFormatter.string(from: record.dateRecorded)
            
            recDict["dateRecorded"] = dateString //date recorded
            recDict["light"] = record.light //light of record
            recDict["moisture"] = record.moisture //moisture of record
            recDict["reservoir"] = record.reservoir //res level of record
            recDict["temperature"] = record.temperature //temperature of record
            recDict["watering"] = record.watering //watering of record
            //append our single record
            recJsonArray.append(recDict)
        }
        //json payload to submit
        let json: [String: Any] =
            [
              "operation": "editPot",
              "tableName": "HydroPotUsers",
              "payload": [
                "Item": [
                    "id": userId,
                    "email": email,
                  "pot": [
                    "automaticWatering": pot.automaticWatering,
                    "id": pot.id,
                    "idealLightHigh": pot.idealLightHigh,
                    "idealLightLow": pot.idealLightLow,
                    "idealMoistureHigh": pot.idealMoistureHigh,
                    "idealMoistureLow": pot.idealMoistureLow,
                    "idealTempHigh": pot.idealTempHigh,
                    "idealTempLow": pot.idealTempLow,
                    "image": pot.image,
                    "notifications": notieJsonArray,
                    "plantName": pot.plantName,
                    "plantType": pot.plantType,
                    "records": recJsonArray
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //url to send to aws
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure and submit the request
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //error response
        session.dataTask(with: request) { data, response, error in}.resume()
        
    }
    
    /// water the pot server side
    ///
    /// - Parameters:
    ///     - encoding: the image data
    ///     - ext: the extension format the image is in
    ///     - pot: the pot the image belongs to
    ///     - onEnded: callback
    func uploadImage(encoding: String, ext: String, pot: Pot, onEnded: @escaping () -> ()) {
        
        //json payload for aws lambda
        let json: [String: Any] =
            [
              "operation": "profileUpload",
              "tableName": "HydroPotUsers",
              "payload": [
                "Item": [
                    "encodedImage": encoding,
                    "fileExtension": ext
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //the aws lambda url to send request
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        //make the request
        var request = URLRequest(url: url)
        
        //post request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // insert json data to the request
        request.httpBody = jsonData

        //configure the request and submit
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        //on recieve
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            //get url where image resides
            var str = String(decoding: d, as: UTF8.self)
            str = str.replacingOccurrences(of: "\"", with: "")
            
            print(str)
            //async queue
            DispatchQueue.main.async(execute: {
                //pot image is at the string
                pot.image = str
                //go back
                onEnded()
            })
        //resume
        }.resume()
    }
}
