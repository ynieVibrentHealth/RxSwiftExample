//
//  UserPreferencesSwitchView.swift
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

class UserPreferencesSwitchView:UIView {
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
    
    fileprivate lazy var dividerLine:UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    }()
    
    public func configure(with viewModel:UserPreferencesSwitchViewModel) {
        titleLabel.text = viewModel.placeHolder
        switchController.rx.isOn.asObservable().bind(to: viewModel.value).addDisposableTo(disposeBag)
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(self).inset(15)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self.switchController.snp.leading).offset(-10)
        }
        
        switchController.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(15).priority(999)
            make.centerY.equalTo(self.titleLabel)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.bottom.equalTo(self)
            make.height.equalTo(1)
        }
        super.updateConstraints()
    }
}
