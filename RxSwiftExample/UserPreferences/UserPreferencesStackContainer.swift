//
//  UserPreferencesStackContainer.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol UserPreferencesViewInput {
    func display(_ state:UserPreferencesModel.Functions.State)
}

class UserPreferencesStackContainer:UIViewController{
    public var output:UserPreferencesInteractorInput?
    fileprivate lazy var router = UserPreferencesRouter(viewController: self)
    
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
    
    fileprivate lazy var accountInfoHeader:UserPreferencesHeaderView = {
        let headerView = UserPreferencesHeaderView()
        headerView.configure(title: "Account Information")
        return headerView
    }()
    
    fileprivate lazy var emailTextField:UserPreferencesTextFieldView = UserPreferencesTextFieldView()
    fileprivate lazy var passwordTextField:UserPreferencesTextFieldView = UserPreferencesTextFieldView()
    
    fileprivate lazy var applicationSettingsHeader:UserPreferencesHeaderView = {
        let headerView = UserPreferencesHeaderView()
        headerView.configure(title: "System Settings")
        return headerView
    }()
    
    fileprivate lazy var emailSettings:UserPreferencesSwitchView = UserPreferencesSwitchView()
    fileprivate lazy var notificationSettings:UserPreferencesPushNotificationsView = UserPreferencesPushNotificationsView()
    fileprivate lazy var smsSettings:UserPreferencesSwitchView = UserPreferencesSwitchView()
    fileprivate lazy var languageSettings:UserPreferencesSelectionView = UserPreferencesSelectionView()
    
    override func viewDidLoad() {
        let request = UserPreferencesModel.Functions.Request.UserDetails
        output?.handle(request)
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.scrollContainer)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        super.viewWillLayoutSubviews()
    }
}

extension UserPreferencesStackContainer: UserPreferencesViewInput {
    func display(_ state: UserPreferencesModel.Functions.State) {
        switch state {
        case .UserDetails(let viewModel):
            displayUserDetails(viewModelDict: viewModel)
        }
    }
    
    private func displayUserDetails(viewModelDict:[String:UserPreferencesViewModel]) {
        stackContainer.addArrangedSubview(accountInfoHeader)
        if let userNameViewModel = viewModelDict[UserPreferencesModel.Keys.Email] as? UserPreferencesTextfieldViewModel{
            stackContainer.addArrangedSubview(emailTextField)
            emailTextField.configure(with: userNameViewModel)
        }
        
        if let passwordViewModel = viewModelDict[UserPreferencesModel.Keys.Password] as? UserPreferencesTextfieldViewModel{
            stackContainer.addArrangedSubview(passwordTextField)
            passwordTextField.changeAction = { () -> Void in
                self.router.navigateTo(destination: .ChangePassword)
            }
            passwordTextField.configure(with: passwordViewModel)
        }
        
        stackContainer.addArrangedSubview(applicationSettingsHeader)
        
        if let emailViewModel = viewModelDict[UserPreferencesModel.Keys.EmailNotifications] as? UserPreferencesSwitchViewModel {
            stackContainer.addArrangedSubview(emailSettings)
            emailSettings.configure(with: emailViewModel)
        }
        
        if let notificationModel = viewModelDict[UserPreferencesModel.Keys.PushNotifcations] as? UserPreferencesNotificationModel {
            stackContainer.addArrangedSubview(notificationSettings)
            notificationSettings.configure(with: notificationModel)
        }
        
        if let smsModel = viewModelDict[UserPreferencesModel.Keys.SMSN] as? UserPreferencesSwitchViewModel {
            stackContainer.addArrangedSubview(smsSettings)
            smsSettings.configure(with: smsModel)
        }
        
        if let languageModel = viewModelDict[UserPreferencesModel.Keys.Language] as? UserPreferencesLanguageModel {
            stackContainer.addArrangedSubview(languageSettings)
            languageSettings.configure(with: languageModel)
        }
    }
}
