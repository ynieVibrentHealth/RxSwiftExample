//
//  FormStackHeaderView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/6/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FormStackHeaderView:UIView {
    fileprivate lazy var headerLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        self.addSubview(label)
        return label
    }()
    
    public func configure(headerText:String){
        headerLabel.text = headerText.capitalized
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        headerLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self).inset(16)
            make.leading.trailing.equalTo(self).inset(10)
            make.bottom.equalTo(self).inset(10)
        }
        super.updateConstraints()
    }
    
}
