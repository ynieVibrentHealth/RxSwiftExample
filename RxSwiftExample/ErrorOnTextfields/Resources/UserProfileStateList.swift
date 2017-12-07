//
//  UserProfileStateList.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/7/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

struct UserProfileStateList {
    public var states:Variable<[UserProfileStateModel]>
    public var statesDict:[String:UserProfileStateModel]
    init() {
        let stateDuple = UserProfileStateList.readJson()
        states = Variable(stateDuple.0)
        statesDict = stateDuple.1
    }
    
    private static func readJson() -> ([UserProfileStateModel], [String:UserProfileStateModel]){
        
        do {
            if let file = Bundle.main.url(forResource: "State", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let states = Mapper<UserProfileStateModel>().mapArray(JSONObject: json) {
                    let sortedStates = states.sorted(by: { (stateOne, stateTwo) -> Bool in
                        return stateOne.name < stateTwo.name
                    })
                    var statesDict:[String:UserProfileStateModel] = [:]
                    for sortedState in sortedStates {
                        statesDict[sortedState.code] = sortedState
                    }
                    
                    return (sortedStates, statesDict)
                }
            }
        } catch {
        }
        
        return ([UserProfileStateModel](),[String:UserProfileStateModel]())
    }
    
}

struct UserProfileStateModel:Mappable {
    var code:String!
    var zipCode:String!
    var hasFlag:Bool!
    var country:String!
    var name:String!
    init?(map:Map) {
        
    }
    
    mutating func mapping(map:Map) {
        code    <- map["code"]
        zipCode <- map["zipCode"]
        hasFlag <- map["hasFlag"]
        country <- map["country"]
        name    <- map["name"]
    }
}
