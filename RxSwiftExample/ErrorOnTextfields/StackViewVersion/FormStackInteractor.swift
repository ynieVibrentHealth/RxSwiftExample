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
    
    private func updateUser(with viewModel:NameViewModel) {
        let userDTO = ACUserDTO()
        userDTO.firstName = viewModel.firstNameValue.value
        userDTO.lastName = viewModel.lastNameValue.value
        userDTO.emailAddress = viewModel.emailAddressValue.value
        
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
