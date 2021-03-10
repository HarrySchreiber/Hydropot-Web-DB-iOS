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
    let deviceToken: String
    let pots: [codePot]?
    
    enum CodingKeys: String, CodingKey {
        case id, email, hashedPW, userName, pots, notifications, deviceToken
    }
}

class GetUser: ObservableObject {
    @Published var userId: String
    @Published var loggedIn: Bool
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var notifications: Bool
    @Published var deviceToken: String
    @Published var pots: [Pot]


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
    
    func login (email: String, password: String, onEnded: @escaping () -> ()) {
        
        //print(UserDefaults.standard.object(forKey: "deviceToken")!)
        
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
            
            // decode the returned data to codable
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
                self.pots = []
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
                                
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir, watering: rec.watering)
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
    
                            var lastWatered = Date()
                            
                            if (records.count != 0){
                                for rec in records.reversed() {
                                    if (rec.watering != 0){
                                        lastWatered = rec.dateRecorded
                                        break
                                    }
                                }
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, resLevel: records[records.count-1].reservoir, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image))
                            }
                            else {
                                self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: Date(), records: records, notifications: notifications, resLevel: 0, curTemp: 0, curLight: 0, curMoisture: 0, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image))
                            }
                        }
                    }
                }
                onEnded()
            })
        }.resume()
    }
    
    func reload (onEnded: @escaping () -> ()) {

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
                                
                                let record = Record(dateRecorded: date ?? Date(), moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir, watering: rec.watering)
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
                            
                            var lastWatered = Date()
                            
                            if (records.count != 0){
                                for rec in records.reversed() {
                                    if (rec.watering != 0){
                                        lastWatered = rec.dateRecorded
                                        break
                                    }
                                }
                                self.replacePot(pot: Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, lastWatered: lastWatered, records: records, notifications: notifications, resLevel: records[records.count-1].reservoir, curTemp: records[records.count-1].temperature, curLight: records[records.count-1].light, curMoisture: records[records.count-1].moisture, id: pot.id, automaticWatering: pot.automaticWatering, image: pot.image))
                            }
                        }
                    }
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    
                }
                onEnded()
            })
        }.resume()
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
        
        let json: [String: Any] = ["operation": "signup", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": email, "password": password, "id": tempID.uuidString, "notifications": notifications, "deviceToken": deviceToken]]]
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
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
    
    func deletePot(Index: Int){


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
        
        
        pots.remove(at: Index)
        
    }
    
    func editPot(pot: Pot){
        
        replacePot(pot: pot)
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        
        var notieJsonArray : [Dictionary<String, Any>] = []

        for notification in pot.notifications {
            var notieDict : [String: String] = [:]
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            notieDict["timeStamp"] = dateString
            notieDict["type"] = notification.type
            notieJsonArray.append(notieDict)
        }
        
        var recJsonArray : [Dictionary<String, Any>] = []
        for record in pot.records {
            var recDict : [String: Any] = [:]
            let dateString = dateFormatter.string(from: record.dateRecorded)
            
            recDict["dateRecorded"] = dateString
            recDict["light"] = record.light
            recDict["moisture"] = record.moisture
            recDict["reservoir"] = record.reservoir
            recDict["temperature"] = record.temperature
            recDict["watering"] = record.watering
            recJsonArray.append(recDict)
        }
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
    
    func changeDeviceToken() {
                
        let json: [String: Any] = ["operation": "changeName", "tableName": "HydroPotUsers", "payload": ["Item": ["email": self.email, "id": self.userId, "deviceToken": self.deviceToken]]]
        
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
    
    func waterPot(pot: Pot, waterAmount: Int){
        
        replacePot(pot: pot)
        
        if (pot.records.count != 0){
            pot.records[pot.records.count-1].watering = waterAmount
            pot.records[pot.records.count-1].dateRecorded = Date()
            pot.lastWatered = Date()
        }
        else {
            pot.records.append(Record(dateRecorded: Date(), moisture: 0, temperature: 0, light: 0, reservoir: 0, watering: waterAmount))
        }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        
        var notieJsonArray : [Dictionary<String, Any>] = []

        for notification in pot.notifications {
            var notieDict : [String: String] = [:]
            let dateString = dateFormatter.string(from: notification.timeStamp)
            
            notieDict["timeStamp"] = dateString
            notieDict["type"] = notification.type
            notieJsonArray.append(notieDict)
        }
        
        var recJsonArray : [Dictionary<String, Any>] = []
        for record in pot.records {
            var recDict : [String: Any] = [:]
            let dateString = dateFormatter.string(from: record.dateRecorded)
            
            recDict["dateRecorded"] = dateString
            recDict["light"] = record.light
            recDict["moisture"] = record.moisture
            recDict["reservoir"] = record.reservoir
            recDict["temperature"] = record.temperature
            recDict["watering"] = record.watering
            recJsonArray.append(recDict)
        }
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
    
    func uploadImage(encoding: String, ext: String, pot: Pot, onEnded: @escaping () -> ()) {
        
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
        
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            var str = String(decoding: d, as: UTF8.self)
            
            str = str.replacingOccurrences(of: "\"", with: "")

            
            DispatchQueue.main.async(execute: {
                pot.image = str
                onEnded()
            })
        }.resume()
    }
}

