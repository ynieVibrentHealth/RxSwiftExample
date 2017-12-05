//
//  FormStackPresenter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

protocol FormStackPresenterInput {
    func process(_ response:FormStackModel.Functions.Response)
}

class FormStackPresenter: FormStackPresenterInput {
    public var output:FormStackViewInput?
    
    func process(_ response: FormStackModel.Functions.Response) {
        switch response {
        case .GetUser(let userDTO):
            generateUserViewModel(dto: userDTO)
        case .UpdateUserStatus(let status):
            let state = FormStackModel.Functions.State.UpdateUserStatus(status: status)
            output?.display(state)
        }
    }
    
    private func generateUserViewModel(dto:ACUserDTO) {
        let firstName = dto.firstName ?? ""
        let lastName = dto.lastName ?? ""
        let emailAddress = dto.emailAddress ?? ""
        
        let viewModel = NameViewModel(lastName: lastName, firstName: firstName, emailAddress: emailAddress)
        let state = FormStackModel.Functions.State.DisplayUser(viewModel: viewModel)
        output?.display(state)
    }
}
