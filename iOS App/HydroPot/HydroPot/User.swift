//
//  User.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/27/21.
//

import Foundation

struct UserResults: Codable {
    let Items: [User]
    let Count: Int
    let ScannedCount: Int
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let hashedPW: String
    let userName: String
    let notifications: Bool
    let pots: [codePot]?
    
    enum CodingKeys: String, CodingKey {
        case id, email, hashedPW, userName, pots, notifications
    }
}

class GetUser: ObservableObject {
    @Published var userId: String
    @Published var loggedIn: Bool
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var notifications: Bool
    @Published var pots: [Pot]


    init() {
        self.userId = ""
        self.loggedIn = false
        self.name = "Spencer The Cool"
        self.email = ""
        self.password = ""
        self.pots = []
        self.notifications = true
    }
    
    func login (email: String, password: String) -> Bool {
        
        let json: [String: Any] =
            ["operation": "login", "tableName": "HydroPotUsers", "payload": ["Item": ["email": email, "password": password]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

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
            
            // decode the returned data into Codable structs
            let results: UserResults?
            do {
                let decoder = JSONDecoder()
                results = try decoder.decode(UserResults.self, from: d)
            } catch {
                results = nil
            }
            guard let r = results else {
                print("Unable to parse user login JSON")
                return
            }
            DispatchQueue.main.async(execute: {
                if ((r.Items.count) != 0) {
                    self.userId = r.Items[0].id
                    self.loggedIn = true
                    self.name = r.Items[0].userName
                    self.email = r.Items[0].email
                    self.password = password
                    self.notifications = r.Items[0].notifications
                    let codePots = r.Items[0].pots
                    if (codePots?.count != 0){
                        for pot in codePots! {
                            var records : [Record] = []
                            for rec in pot.records! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir)
                                records.append(record)
                            }
                            var notifications : [Notification] = []
                            for notie in pot.notifications! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: notie.timeStamp)
                                
                                let notification = Notification(type: notie.type, timeStamp: date ?? Date())
                                notifications.append(notification)
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                            let date = dateFormatter.date(from: pot.lastWatered)
                            
                            self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: date ?? Date(), records: records, notifications: notifications, resLevel: pot.resLevel, curTemp: pot.curTemp, curLight: pot.curLight, curMoisture: pot.curMoisture, id: pot.id, automaticWatering: pot.automaticWatering))
                        }
                    }
                    
                }
            })
        }.resume()
        
        return loggedIn
    }
    
    func reload (onEnded: @escaping () -> ()) -> Bool {
        
        pots = []
        
        let json: [String: Any] =
            ["operation": "login", "tableName": "HydroPotUsers", "payload": ["Item": ["email": email, "password": password]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

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
            
            // decode the returned data into Codable structs
            let results: UserResults?
            do {
                let decoder = JSONDecoder()
                results = try decoder.decode(UserResults.self, from: d)
            } catch {
                results = nil
            }
            guard let r = results else {
                print("Unable to parse user login JSON")
                return
            }
            DispatchQueue.main.async(execute: {
                if ((r.Items.count) != 0) {
                    self.notifications = r.Items[0].notifications
                    let codePots = r.Items[0].pots
                    if (codePots?.count != 0){
                        for pot in codePots! {
                            var records : [Record] = []
                            for rec in pot.records! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir)
                                records.append(record)
                            }
                            var notifications : [Notification] = []
                            for notie in pot.notifications! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: notie.timeStamp)
                                
                                let notification = Notification(type: notie.type, timeStamp: date ?? Date())
                                notifications.append(notification)
                            }
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                            let date = dateFormatter.date(from: pot.lastWatered)
                            print(pot.curMoisture)
                            self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: date ?? Date(), records: records, notifications: notifications, resLevel: pot.resLevel, curTemp: pot.curTemp, curLight: pot.curLight, curMoisture: pot.curMoisture, id: pot.id, automaticWatering: pot.automaticWatering))
                        }
                    }
                    
                }
            })
            onEnded()
        }.resume()
        return loggedIn
    }
    
    func changePass(newPass: String) {
        self.password = newPass
    }
    
    func logout() {
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
    }
    
    func signup(name: String, email: String, password: String) {
        
        let tempID = UUID()
        
        let json: [String: Any] = ["operation": "signup", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": email, "password": password, "id": tempID.uuidString, "notifications": notifications]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in }.resume()
        
        self.userId = tempID.uuidString
        self.loggedIn = true
        self.name = name
        self.email = email
        self.password = password
        self.pots = []

    }
    
    func addPlant(pot: Pot) {
        pot.lastWatered = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = dateFormatter.string(from: pot.lastWatered)
        
        pots.append(pot)
        

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
                    "curLight": pot.curLight,
                    "curMoisture": pot.curMoisture,
                    "curTemp": pot.curTemp,
                    "id": pot.id,
                    "idealLightHigh": pot.idealLightHigh,
                    "idealLightLow": pot.idealTempLow,
                    "idealMoistureHigh": pot.idealMoistureHigh,
                    "idealMoistureLow": pot.idealMoistureLow,
                    "idealTempHigh": pot.idealTempHigh,
                    "idealTempLow": pot.idealTempLow,
                    "image": "https://www.gardeningknowhow.com/wp-content/uploads/2012/03/houseplant-sansevieria.jpg",
                    "lastWatered": date,
                    "notifications": [],
                    "plantName": pot.plantName,
                    "plantType": pot.plantType,
                    "resLevel": pot.resLevel,
                    "records": []
                  ]
                ]
              ]
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in}.resume()
    }
    
    func replacePot(pot: Pot){
        for (index, _) in pots.enumerated() {
            if (self.pots[index].id == pot.id){
                self.pots[index] = pot
            }
        }
    }
    
    func deletePot(at offsets: IndexSet){

        for index in offsets {
            let json: [String: Any] =
                [
                  "operation": "deletePot",
                  "tableName": "HydroPotUsers",
                  "payload": [
                    "Item": [
                        "id": userId,
                        "email": email,
                      "pot": [
                        "id": pots[index].id,
                      ]
                    ]
                  ]
                ]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
            
            var request = URLRequest(url: url)
            
            request.httpMethod = "POST"
            request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // insert json data to the request
            request.httpBody = jsonData

            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Accept": "Application/json"]
            let session = URLSession(configuration: config)
            
            session.dataTask(with: request) { data, response, error in}.resume()
            
          }
        
        pots.remove(atOffsets: offsets)
        
    }
    
    func editPot(pot: Pot){
        
        replacePot(pot: pot)
        
        pot.lastWatered = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let date = dateFormatter.string(from: pot.lastWatered)

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
                    "curLight": pot.curLight,
                    "curMoisture": pot.curMoisture,
                    "curTemp": pot.curTemp,
                    "id": pot.id,
                    "idealLightHigh": pot.idealLightHigh,
                    "resLevel": pot.resLevel,
                    "idealLightLow": pot.idealLightLow,
                    "idealMoistureHigh": pot.idealMoistureHigh,
                    "idealMoistureLow": pot.idealMoistureLow,
                    "idealTempHigh": pot.idealTempHigh,
                    "idealTempLow": pot.idealTempLow,
                    "image": "https://www.gardeningknowhow.com/wp-content/uploads/2012/03/houseplant-sansevieria.jpg",
                    "lastWatered": date,
                    "notifications": [],
                    "plantName": pot.plantName,
                    "plantType": pot.plantType,
                    "records": []
                  ]
                ]
              ]
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in}.resume()
        
    }
    
    struct notiePots: Identifiable {
        var id: Int
        
        var notiesTuple : (pot: Pot, notification: Notification)

    }
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
        print(notiesTupleList)
        return notiesTupleList
        
    }
    
    func changePass(password: String) {
        
        self.password = password
        
        let json: [String: Any] = ["operation": "changePass", "tableName": "HydroPotUsers", "payload": ["Item": ["name": self.name, "email": self.email, "password": password, "id": self.userId]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    func changeName(name: String) {
        
        self.name = name
        
        let json: [String: Any] = ["operation": "changeName", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": self.email, "password": password, "id": self.userId]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    func toggleNotifications(notifications: Bool) {
        
        self.notifications = notifications
        
        let json: [String: Any] = ["operation": "toggleNotis", "tableName": "HydroPotUsers", "payload": ["Item": ["name": self.name, "email": self.email, "notifications": notifications, "id": self.userId]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in }.resume()

    }
    
    func attemptReload(){
        self.reload() {
            // will be received at the login processed
            if self.loggedIn {
                print("")
            }
            else{
                print("You aren't logged in")
            }
        }
    }
    
}
