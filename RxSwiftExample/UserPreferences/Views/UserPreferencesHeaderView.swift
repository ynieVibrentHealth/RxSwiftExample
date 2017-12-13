//
//  UserPreferencesHeaderView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit

class UserPreferencesHeaderView:UIView {
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    }()
    
    public func configure(title:String) {
        self.titleLabel.text = title
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.top.bottom.equalTo(self).inset(20).priority(999)
        }
        dividerLine.snp.updateConstraints { (make) in
            make.bottom.equalTo(self).inset(10)
            make.leading.trailing.equalTo(self).inset(10).priority(999)
            make.height.equalTo(1)
        }
        super.updateConstraints()
    }
}
