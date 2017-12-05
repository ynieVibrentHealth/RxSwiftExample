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
        userDTO.emailAddress = "ynie@vibrenthealth.com"
        
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
            userDTO.emailAddress = emailModel.value.value
        }
        
        print("updating user...firstName: \(userDTO.firstName!), \n last name: \(userDTO.lastName!) \n email address: \(userDTO.emailAddress!)")
        let response = FormStackModel.Functions.Response.UpdateUserStatus(status: true)
        output?.process(response)
    }
}

class ACUserDTO {
    var firstName:String?
    var lastName:String?
    var emailAddress:String?
}
