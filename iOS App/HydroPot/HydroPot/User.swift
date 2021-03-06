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
    Codable to hold results from aws api call
 */
struct addResults: Codable {
    let result: Bool //if we added or nah
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
    let pots: [CodePot]? //pots the user has
    
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
    @Published var url: URL

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
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
        self.notifications = true
        self.deviceToken =   UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        self.url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
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
                                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                                
                                let date = dateFormatter.date(from: rec.dateRecorded)

                                //make record
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, watering: rec.watering)
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
                                let notification = Notification(type: notie.type, read: notie.read, timeStamp: date ?? Date())
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
                                
                                //format date
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                
                                //todays string
                                let todayString = dateFormatter.string(from: Date())
                                //get last date
                                let lastDate = dateFormatter.date(from: pot.lastFilled ?? todayString)
                                
                                //append the newly created pot with our record
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id, lastFilled: lastDate!, notiFilledFrequency: pot.notiFilledFrequency ?? 2))
                            }
                            //if we don't have a record create this pot
                            else {
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: Date(), records: records, notifications: notifications, curTemp: 0, curLight: 0, curMoisture: 0, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id, lastFilled: Date(), notiFilledFrequency: pot.notiFilledFrequency ?? 2))
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
                                dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                                
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                //make record
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, watering: rec.watering)
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
                                let notification = Notification(type: notie.type, read: notie.read, timeStamp: date ?? Date())
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
                                
                                //date formatter
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                
                                //todays string
                                let todayString = dateFormatter.string(from: Date())
                                //get last date
                                let lastDate = dateFormatter.date(from: pot.lastFilled ?? todayString)
                                
                                //append the newly created pot with our record
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id, lastFilled: lastDate!, notiFilledFrequency: pot.notiFilledFrequency ?? 2))
                            }
                            //if we don't have a record create this pot
                            else {
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: Date(), records: records, notifications: notifications, curTemp: 0, curLight: 0, curMoisture: 0, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image, potId: pot.id, lastFilled: Date(), notiFilledFrequency: pot.notiFilledFrequency ?? 2))
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
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
        self.loggedIn = false
    }
    
    /// Signing up the user to aws
    ///
    /// - Parameters:
    ///     - name: Name of the user
    ///     - email: Email of the user
    ///     - password: Password of the user
    func signup(name: String, email: String, password: String, onEnded: @escaping () -> ()) {
        
        //create the users ID
        let tempID = UUID()
        
        //create payload for aws lambda
        let json: [String: Any] = ["operation": "signup", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": email, "password": password, "id": tempID.uuidString, "notifications": notifications, "deviceToken": deviceToken]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

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
                //if we have a user
                if ((r.Items.count) == 0) {
                    self.userId = tempID.uuidString //user id
                    self.loggedIn = true //logged in
                    self.name = name //user name
                    self.email = email //user email
                    self.password = password //user password
                    self.pots = [] //user has no pots
                    //permanent login for leaving app
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
                //return to callback
                onEnded()
            })
                    
        }.resume()
        

    }
    
    /// Adding pot to user through aws
    ///
    /// - Parameters:
    ///     - pot: The user's pot to be added
    func addPlant(pot: Pot, onEnded: @escaping () -> ()) {
        
        //date formatter for various dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

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
                    "records": [],
                    "lastFilled":  dateFormatter.string(from: pot.lastFilled),
                    "notiFilledFrequency": pot.notiFilledFrequency
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

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
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            // decode the returned data to codable
            let results: addResults?
            do {
                //decoding the data
                let decoder = JSONDecoder()
                //try to decode into our codable
                results = try decoder.decode(addResults.self, from: d)
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
                //if we don't have a pot
                if ((r.result) == true) {
                    //append the pot client side
                    self.pots.append(pot)
                }
                //return to callback
                onEnded()
            })
            
        }.resume()
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
            var notieDict : [String: Any] = [:]
            //format timestamp
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            //our values
            notieDict["timeStamp"] = dateString
            notieDict["read"] = notification.read
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
            
            let tempDate = Calendar.current.date(byAdding: .hour, value: 4, to: record.dateRecorded)!
            //for date on record
            let dateString = dateFormatter.string(from: tempDate)

            
            //values for the records
            recDict["dateRecorded"] = dateString //date recorded
            recDict["light"] = record.light //light of record
            recDict["moisture"] = record.moisture //moisture of record
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
                    "records": recJsonArray,
                    "lastFilled":  dateFormatter.string(from: pot.lastFilled),
                    "notiFilledFrequency": pot.notiFilledFrequency
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

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
    func getOrderedNotifications() ->  [NotificationPots] {
        //make list of tuples, pot : notification
        //for each pot, add notification
        var notificationsTupleList : [NotificationPots] = []
        var counter = 0
        for pot in pots {
            for notie in pot.notifications {
                counter += 1
                let NotificationPot = NotificationPots(id: counter, notiesTuple: (pot, notie))
                notificationsTupleList.append(NotificationPot)
            }
        }
        //sort list of tuples
        notificationsTupleList = notificationsTupleList.sorted(by: {
            $0.notiesTuple.notification.timeStamp.compare($1.notiesTuple.notification.timeStamp) == .orderedDescending
        })
        //return
        return notificationsTupleList
        
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
        let json: [String: Any] = ["operation": "changeDeviceToken", "tableName": "HydroPotUsers", "payload": ["Item": ["email": self.email, "id": self.userId, "deviceToken": self.deviceToken]]]
        
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
    
    /// deletes the ccount and signs them out
    ///
    func deleteAccount() {
        
        //json payload to send to aws lambda
        let json: [String: Any] = ["operation": "deleteAccount", "tableName": "HydroPotUsers", "payload": ["Item": ["email": self.email, "id": self.userId]]]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

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
        
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
        self.notifications = true
        self.deviceToken =   UserDefaults.standard.string(forKey: "deviceToken") ?? ""
        self.url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!

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
            pot.setLastWatered(lastWatered: Date())
            
        }
        //if we don't have records then we create a dummy record for the pot to know we want to water
        else {
            pot.records.append(Record(dateRecorded: Date(), moisture: 0, temperature: 0, light: 0, watering: waterAmount))
        }
                
       //format for dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        //making array for notis json
        var notieJsonArray : [Dictionary<String, Any>] = []

        //for every noti
        for notification in pot.notifications {
            //make noti dict
            var notieDict : [String: Any] = [:]
            //format timestamp
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            //our values
            notieDict["timeStamp"] = dateString
            notieDict["read"] = notification.read
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
            
            var tempDate = Calendar.current.date(byAdding: .hour, value: 4, to: record.dateRecorded)!
            //for date on record
            let dateString = dateFormatter.string(from: tempDate)
            
            
            recDict["dateRecorded"] = dateString //date recorded
            recDict["light"] = record.light //light of record
            recDict["moisture"] = record.moisture //moisture of record
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
                    "records": recJsonArray,
                    "lastFilled":  dateFormatter.string(from: pot.lastFilled),
                    "notiFilledFrequency": pot.notiFilledFrequency
                  ]
                ]
              ]
            ]
        
        //jsonify the data
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

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
