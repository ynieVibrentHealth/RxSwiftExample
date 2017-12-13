//
//  UserPreferencesSelectionView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/13/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserPreferencesSelectionView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate lazy var selectionTextField:UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        self.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    }()
    
    
    
    fileprivate lazy var actionLabel:UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        self.addSubview(button)
        return button
    }()
    
    fileprivate var viewModel:UserPreferencesTextfieldViewModel?
    public var changeAction:(() -> Void)?
    
    public func configure(with viewModel:ProfileFieldViewModel) {
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        actionLabel.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(20)
            make.centerY.equalTo(self.selectionTextField)
            make.width.lessThanOrEqualTo(150)
        }
        
        selectionTextField.snp.updateConstraints { (make) in
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(actionLabel.snp.leading).offset(-10).priority(999)
            make.top.equalTo(self).inset(10).priority(999)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.top.equalTo(self.selectionTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.dividerLine.snp.bottom).offset(5)
            make.leading.trailing.equalTo(dividerLine)
            make.bottom.equalTo(self).inset(10).priority(999)
        }
        super.updateConstraints()
    }
}

