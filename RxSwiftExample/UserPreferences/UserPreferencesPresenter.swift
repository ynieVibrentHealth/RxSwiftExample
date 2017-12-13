//
//  UserPreferencesPresenter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift
import UserNotifications

protocol UserPreferencesPresenterInput {
    func process(_ response:UserPreferencesModel.Functions.Response)
}

class UserPreferencesPresenter:UserPreferencesPresenterInput {
    public var output:UserPreferencesViewInput?
    
    func process(_ response: UserPreferencesModel.Functions.Response) {
        switch response {
        case .UserDetails(let userDTO):
            generateViewModel(with: userDTO)
        }
    }
    
    private func generateViewModel(with userDTO:ACUserDTO) {
        let email = userDTO.email ?? ""
        let password = userDTO.password ?? ""
        
        let emailViewModel = UserPreferencesTextfieldViewModel(value: email, placeHolder: "Email Address")
        let passwordViewModel = UserPreferencesTextfieldViewModel(value: password, placeHolder: "Password", type: .Hidden)
        
        
        
        var userPrefsDict:[String:UserPreferencesViewModel] = [UserPreferencesModel.Keys.Email:emailViewModel,
                                                               UserPreferencesModel.Keys.Password:passwordViewModel]
        
        let preferences = generatePreferencesModel(with: userDTO.userPreferences)
        for (key, value) in preferences {
            userPrefsDict[key] = value
        }
        
        pushNotificationsViewModel(with: userDTO.userPreferences) { [weak self] (viewModelDict) in
            DispatchQueue.main.async {
                for (key, value) in viewModelDict {
                    userPrefsDict[key] = value
                }
                let state = UserPreferencesModel.Functions.State.UserDetails(preferencesViewModel: userPrefsDict)
                self?.output?.display(state)
            }
        }
    }
    
    private func generatePreferencesModel(with preferencesDTO:ACUserPreferencesDTO?) -> [String:UserPreferencesViewModel]{
        guard let preferencesDTO = preferencesDTO else {
            return [UserPreferencesModel.Keys.EmailNotifications:getDefaultEmailModel()]
        }
        let emailNotifications = preferencesDTO.emailNotifications ?? false
        let localeModel = preferencesDTO.locale ?? "en"
        
        let localViewModel = UserPreferencesLanguageModel(locale: ACLocaleMaster(rawValue: localeModel)!, placeHolder: "Language")
        
        //todo: add in sms options when that's available
        let emailViewModel = UserPreferencesSwitchViewModel(value: emailNotifications, placeHolder: "Email Notifications")
        return [UserPreferencesModel.Keys.EmailNotifications: emailViewModel, UserPreferencesModel.Keys.Language:localeModel]
    }
    
    private func pushNotificationsViewModel(with preferenceDTO:ACUserPreferencesDTO?, completion:@escaping (_ notificationViewModel:[String:UserPreferencesNotificationModel]) -> Void){
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            if granted {
                let notifcation = UserPreferencesNotificationModel.NotifcationSetting.notifcationSetting(with: preferenceDTO?.pushNotifications ?? false)
                let viewModel = UserPreferencesNotificationModel(value: notifcation, placeHolder: "Push Notifications")
                completion([UserPreferencesModel.Keys.PushNotifcations:viewModel])
            } else {
                let viewModel = UserPreferencesNotificationModel(value: .SystemDisabled, placeHolder: "Push notifcations")
                completion([UserPreferencesModel.Keys.PushNotifcations:viewModel])
            }
        })
    }
    
}

extension UserPreferencesPresenter {//Default values
    fileprivate func getDefaultEmailModel() -> UserPreferencesSwitchViewModel {
        return UserPreferencesSwitchViewModel(value: false, placeHolder: "Email Notifications")
    }
    
    fileprivate func getDefaultNotifcationsModel() -> UserPreferencesNotificationModel {
        return UserPreferencesNotificationModel(value: .SystemDisabled, placeHolder: "Notication Setting")
    }
}
