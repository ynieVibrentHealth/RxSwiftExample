//
//  ColorPickerExample.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/3/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ColorPickerExample:UIViewController {
    fileprivate lazy var circle:UIView = {
        let view = UIView()
        view.backgroundColor = .green
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ColorPickerExample.circleMoved(_:)))
        view.addGestureRecognizer(gesture)
        view.rx.observe(CGPoint.self, "center")
            .bind(to: self.circleViewModel.centerVariable)
            .addDisposableTo(self.disposeBag)
        view.rx.observe(CGPoint.self, "center")
            .bind(to: self.circleViewModel.yAxis)
            .addDisposableTo(self.disposeBag)
        self.view.addSubview(view)
        return view
    }()
    
    fileprivate lazy var label:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        self.view.addSubview(label)
        return label
    }()
    
    let disposeBag:DisposeBag = DisposeBag()
    
    fileprivate lazy var circleViewModel:CircleViewModel = {
        let vm = CircleViewModel()
        vm.backgroundColorObservable
            .subscribe(onNext: { [weak self] (color) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.backgroundColor = color
            })
        }).addDisposableTo(self.disposeBag)
        
        vm.coordinateObservable.asObservable().map({ (input) -> String in
            return input
        }).bind(to: self.label.rx.text).addDisposableTo(self.disposeBag)
        return vm
    }()
    
    func circleMoved(_ recognizer:UIPanGestureRecognizer) {
        let location = recognizer.location(in: self.view)
        UIView.animate(withDuration: 0.1) {
            self.circle.center = location
        }
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        super.viewDidLoad()
    }
    
    override func updateViewConstraints() {
        circle.snp.updateConstraints { (make) in
            make.center.equalTo(self.view)
            make.height.equalTo(100)
            make.width.equalTo(circle.snp.height)
        }
        
        label.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view).inset(10)
            make.trailing.leading.equalTo(self.view).inset(10)
        }
        super.updateViewConstraints()
    }
    
    override func viewWillLayoutSubviews() {

        
        super.viewWillLayoutSubviews()
        circle.layer.cornerRadius = 100/2
    }
}

