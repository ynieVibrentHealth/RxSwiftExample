//
//  FormStackController.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa

protocol FormStackViewInput {
    func display(_ state:FormStackModel.Functions.State)
}

class FormStackController:UIViewController {
    public var output:FormStackInteractorInput?
    
    fileprivate lazy var scrollContainer:UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    fileprivate lazy var stackContainer:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        self.scrollContainer.addSubview(stackView)
        return stackView
    }()
    
    
    /**
     Instead of using the standard target action that UIKit uses, this leverages the RxCocoa framework to inject the action that responds to user tap.
     
     There’s nothing wrong with the methodology of defining a selector, however, having an action that runs in a different area of code can cause confusing.
     
     By doing this, we are able to set the action directly in the block initialization of the button.

     **/
    fileprivate lazy var barButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        barButton.rx.tap
            .subscribe({ [weak self] (tap) in
                guard let viewModel = self?.profileDict else {return}
                let request = FormStackModel.Functions.Request.UpdateUser(profileDict: viewModel)
                self?.output?.handle(request)
            }).addDisposableTo(self.disposeBag)
        return barButton
    }()
    
    fileprivate lazy var disposeBag = DisposeBag()
    fileprivate lazy var profileDict:[String:ProfileFieldViewModel] = [:]
    
    /**
     Initializing each textField view. The only property that’s injected is the validation function; each textfield has a unique validation to determine if the user input matches what we expect. In addition, it also sets the error message for the case that the user input text is not valid. For instance, if the user enters an email address that isn’t valid, the error message displayed is:
     “Please enter a valid email address”
     
     Whereas if the user doesn’t enter an email address, the error message should be:
     “Email address is required”

     **/
    
    fileprivate lazy var firstNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        return inputField
    }()
    
    fileprivate lazy var lastNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        return inputField
    }()
    
    fileprivate lazy var emailView:FormTextFieldView = {
       let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackContainer.addArrangedSubview(firstNameView)
        self.stackContainer.addArrangedSubview(lastNameView)
        self.stackContainer.addArrangedSubview(emailView)
        self.navigationItem.rightBarButtonItem = barButton
        
        //sending request to interactor
        let request = FormStackModel.Functions.Request.GetUser
        output?.handle(request)
    }
    
    override func viewWillLayoutSubviews() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        stackContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(scrollContainer)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        super.viewWillLayoutSubviews()
    }
}

extension FormStackController:FormStackViewInput {
    func display(_ state: FormStackModel.Functions.State) {
        switch state {
        case .DisplayUser(let viewModel):
            setupUser(with: viewModel)
        case .UpdateUserStatus(let status):
            handleUpdateUser(status: status)
        }
    }
    
    private func handleUpdateUser(status:Bool) {
        if status{
            print("Update user successful")
        } else {
            print("Update user failed")
        }
    }
    
    private func setupUser(with modelDict:[String:ProfileFieldViewModel]) {
        /**
         Configuring each view with the appropriate properties including placeholder, validity model (a variable type containing a Bool), and the value model.
         **/
        
        var observables:[Observable<Bool>] = []
        if let firstNameModel = modelDict[ProfileFieldKeys.FIRST_NAME] {
            firstNameView.configure(profileViewModel: firstNameModel)
            observables.append(firstNameModel.isValid.asObservable())
        }
        
        if let lastNameModel = modelDict[ProfileFieldKeys.LAST_NAME] {
            lastNameView.configure(profileViewModel: lastNameModel)
            observables.append(lastNameModel.isValid.asObservable())
        }
        
        if let emailModel = modelDict[ProfileFieldKeys.EMAIL_ADDRESS] {
            emailView.configure(profileViewModel: emailModel)
            observables.append(emailModel.isValid.asObservable())
        }
        self.profileDict = modelDict
        /**
         Combining the validation values for all fields
         In this function, the observable class is combining the checks of the name fields, and email field are valid and binding them to the state of the save bar button.
         **/
        Observable.combineLatest(observables) { (values) -> Bool in
            for value in values {
                if !value {
                    return false
                }
            }
            return true
        }.bind(to: self.barButton.rx.isEnabled).addDisposableTo(self.disposeBag)
    }
}
