//
//  UserPreferencesButtonView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/15/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserPreferencesButtonView:UIView {
    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var actionButton:UIButton = {
        let button = UIButton()
        button.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.action?()
        }).addDisposableTo(self.disposeBag)
        button.setTitleColor(.blue, for: .normal)
        self.addSubview(button)
        return button
    }()
    
    public var action:(() -> Void)?
    
    func configure(with viewModel:UserPreferencesButtonViewModel) {
        actionButton.setTitle(viewModel.placeHolder, for: .normal)
        self.action = viewModel.action
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        actionButton.snp.updateConstraints { (make) in
            make.leading.equalTo(self).inset(20)
            make.top.bottom.equalTo(self).inset(5)
            make.trailing.lessThanOrEqualTo(self).inset(20)
        }
        super.updateConstraints()
    }
}
