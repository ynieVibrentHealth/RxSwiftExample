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
    
    override func viewWillLayoutSubviews() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        stackContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        super.viewWillLayoutSubviews()
    }
}

extension UserPreferencesStackContainer: UserPreferencesViewInput {
    func display(_ state: UserPreferencesModel.Functions.State) {
        
    }
}
