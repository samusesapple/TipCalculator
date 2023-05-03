//
//  CalculatorViewModel.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import Foundation
import Combine

class CalculatorViewModel {
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        input.tipPublisher.sink { tip in
            print("VM tip : \(tip)")
        }.store(in: &cancellables)
        
        let result = Result(totalBill: 500,
                            totalTip: 50.0,
                            amountPerPerson: 2)
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
    
}
