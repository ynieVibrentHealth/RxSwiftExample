//
//  FormStackInteractor.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

protocol FormStackInteractorInput {
    func handle(_ request:FormStackModel.Functions.Request)
}

class FormStackInteractor: FormStackInteractorInput {
    public var output:FormStackPresenterInput?
    
    func handle(_ request: FormStackModel.Functions.Request) {
        switch request {
        case .GetUser:
            mockUserDTO()
        case .UpdateUser(let viewModel):
            updateUser(with: viewModel)
        }
    }
    
    private func mockUserDTO() {
        let userDTO = ACUserDTO()
        userDTO.firstName = "Yuchen"
        userDTO.lastName = "Nie"
        userDTO.middleInitial = "K"
        userDTO.email = "ynie@vibrenthealth.com"
        userDTO.dob = 932443200000
        userDTO.phoneNumber = "1232412321"
        
        let addressDTO = ACUserAddressDTO()
        addressDTO.streetOne = "1234 North Caleredon Ave."
        addressDTO.streetTwo = "#1234"
        addressDTO.city = "Fairfax"
        addressDTO.state = "Virginia"
        addressDTO.zip = "22033"
        
        userDTO.address = addressDTO
        
        let response = FormStackModel.Functions.Response.GetUser(userDTO: userDTO)
        output?.process(response)
    }
    
    private func updateUser(with profileDict:[String:ProfileFieldViewModel]) {
        let userDTO = ACUserDTO()
        if let firstNameModel = profileDict[ProfileFieldKeys.FIRST_NAME] {
            userDTO.firstName = firstNameModel.value.value
        }
        
        if let lastNameModel = profileDict[ProfileFieldKeys.LAST_NAME] {
            userDTO.lastName = lastNameModel.value.value
        }
        
        if let emailModel = profileDict[ProfileFieldKeys.EMAIL_ADDRESS] {
            userDTO.email = emailModel.value.value
        }
        
        print("updating user...firstName: \(userDTO.firstName!), \n last name: \(userDTO.lastName!) \n email address: \(userDTO.email!)")
        let response = FormStackModel.Functions.Response.UpdateUserStatus(status: true)
        output?.process(response)
    }
}

class ACUserDTO : NSObject{
    var activated : Bool?
    var address : ACUserAddressDTO?
    var authenticationKey : String?
    var authorities : Array<String>?
    var createdBy : String?
    var createdDate : NSNumber?
    var dob : NSNumber?
    var domainId : NSNumber?
    var email : String?
    var externalId : String?
    var failedLoginAttempts : Int?
    var firstName : String?
    var id : NSNumber?
    var inviteCode : String?
    var lastModifiedBy : String?
    var lastModifiedDate : NSNumber?
    var lastName : String?
    var locked : Bool?
    var login : String?
    var middleInitial : String?
    var password : String?
    var phoneNumber : String?
    var profileImageUrl : String?
    var resetKey : String?
    var role : String?
    var unlockTime : NSNumber?
}

class ACUserAddressDTO : NSObject{
    var city : String?
    var id : NSNumber?
    var latitude : Double?
    var longitude : Double?
    var phoneNumber : String?
    var state : String?
    var streetOne : String?
    var streetTwo : String?
    var unitNumber : String?
    var zip : String?
}
