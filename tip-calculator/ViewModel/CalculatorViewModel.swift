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
        let viewTapPublisher: AnyPublisher<Void, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
        let resetKeyboardPublisher: AnyPublisher<Void, Never>
    }
    
    var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self] bill, tip, split in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                let result = Result(totalBill: totalBill,
                                    totalTip: totalTip,
                                    amountPerPerson: amountPerPerson)
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resetCalculatorPublisher = input.logoViewTapPublisher
        let resetKeyboardPublisher = input.viewTapPublisher
        return Output(updateViewPublisher: updateViewPublisher,
                      resetCalculatorPublisher: resetCalculatorPublisher,
                      resetKeyboardPublisher: resetKeyboardPublisher)
    }
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
    
    
}
