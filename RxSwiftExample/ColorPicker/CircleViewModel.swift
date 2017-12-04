//
//  CircleViewModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/3/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CircleViewModel {
    var centerVariable = Variable<CGPoint?>(.zero)
    var backgroundColorObservable:Observable<UIColor>!
    
    var yAxis = Variable<CGPoint?>(.zero)
    var coordinateObservable:Observable<String>!
    
    init() {
        backgroundColorObservable = centerVariable.asObservable()
            .map({ (center) -> UIColor in
                guard let center = center else {return UIColor.black}
                let remainder = (center.x + center.y).truncatingRemainder(dividingBy: 255.0)
                let red:CGFloat = remainder/255.0
                let green:CGFloat = 0
                let blue:CGFloat = 0
                
                return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            })
        
        coordinateObservable = yAxis.asObservable()
            .map({ (coordinate) -> String in
                guard let frame = coordinate else {return "0"}
                return "\(frame.y)"
            })
    }
}
