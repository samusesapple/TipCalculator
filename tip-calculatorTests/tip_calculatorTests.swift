//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by Sam Sung on 2023/05/02.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {
    
    // SUT -> System Under Test
    private var sut: CalculatorViewModel!
    private var cancellables: Set<AnyCancellable>!
    
    private let viewTapSubject = PassthroughSubject<Void, Never>()
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()
    
    override func setUp() {
        sut = .init()
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    // 테스트 시나리오 설계 - 팁 없이 100 달러를 1명이 낼 경우
    func testResultWithoutTipFor1Person() {
        // Given - 테스트에 대입할 dummy데이터
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        // When - MVVM 패턴, viewModel에 given 데이터가 들어가는 시나리오
        let output = sut.transform(input: viewModelInput(bill: bill, tip: tip, split: split))
        // Then - 결과 예측과 일치한지 확인
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    private func viewModelInput(bill: Double, tip: Tip, split: Int) -> CalculatorViewModel.Input {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPublisher: Just(split).eraseToAnyPublisher(),
                     viewTapPublisher: viewTapSubject.eraseToAnyPublisher(),
                     logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
    
}
