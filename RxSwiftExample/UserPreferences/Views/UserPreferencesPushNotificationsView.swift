//
//  UserPreferencesPushNotificationsView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/13/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserPreferencesPushNotificationsView:UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var switchController:UISwitch = {
        let control = UISwitch()
        self.addSubview(control)
        return control
    }()
    
    fileprivate lazy var actionLabel:UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        self.addSubview(button)
        return button
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    }()
    
    private var shouldShowSwitch:Bool = false
    
    public func configure(with viewModel:UserPreferencesNotificationModel) {
        titleLabel.text = viewModel.placeHolder
        switch viewModel.value.value {
        case .SystemDisabled:
            shouldShowSwitch = false
            switchController.isHidden = true
        default:
            configureForSwitch(with: viewModel)
        }
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    private func configureForSwitch(with viewModel:UserPreferencesNotificationModel) {
        shouldShowSwitch = true
        actionLabel.isHidden = true
    }
    
    override func updateConstraints() {
        titleLabel.snp.remakeConstraints { (make) in
            make.top.bottom.equalTo(self).inset(15).priority(999)
            make.leading.equalTo(self).inset(20)
            if self.shouldShowSwitch {
                make.trailing.equalTo(self.switchController.snp.leading).offset(-10)
            } else {
                make.trailing.equalTo(self.actionLabel.snp.leading).offset(-10)
            }
        }
        
        if shouldShowSwitch {
            switchController.snp.remakeConstraints { (make) in
                make.trailing.equalTo(self).inset(15).priority(999)
                make.centerY.equalTo(self.titleLabel)
            }
        } else {
            actionLabel.snp.remakeConstraints { (make) in
                make.trailing.equalTo(self).inset(15).priority(999)
                make.centerY.equalTo(self.titleLabel)
            }
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        super.updateConstraints()
    }
}
