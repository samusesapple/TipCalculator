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
    private var audioPlayerService: MockAudioPlayerService!
    
    override func setUp() {
        sut = .init(audioPlayerService: audioPlayerService)
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    // MARK: - TestCases
    
    // 테스트 시나리오 설계 - 팁 없이 100 달러를 1명이 낼 경우
    func testResultWithoutTipFor1Person() {
        // Given - 테스트에 대입할 dummy데이터
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        // When - MVVM 패턴, viewModel에 given 데이터가 들어가는 시나리오
        let output = sut.transform(input: viewModelInput(bill: bill, tip: tip, split: split))
        // Then - 결과값이 예측값과 일치한지 비교
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        // Given - 테스트에 대입할 dummy데이터
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        // When - VM에 Given 데이터가 들어가면
        let output = sut.transform(input: viewModelInput(bill: bill, tip: tip, split: split))
        // Then - 결과값이 예측값과 일치한지 비교
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWith10PercentTipFor2Person() {
        // Given - 테스트에 대입할 dummy데이터
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        // When - VM에 Given 데이터가 들어가면
        let output = sut.transform(input: viewModelInput(bill: bill, tip: tip, split: split))
        // Then - 결과값이 예측값과 일치한지 비교
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4Person() {
        // Given - 테스트에 대입할 dummy데이터
        let bill: Double = 200.0
        let tip: Tip = .custom(value: 50)
        let split: Int = 4
        // When - VM에 Given 데이터가 들어가면
        let output = sut.transform(input: viewModelInput(bill: bill, tip: tip, split: split))
        // Then - 결과값이 예측값과 일치한지 비교
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 250 / 4)
            XCTAssertEqual(result.totalBill, 250.0)
            XCTAssertEqual(result.totalTip, 50)
        }.store(in: &cancellables)
    }
    
    private func testSoundPlayedAndCalculatorResetWhenLogoViewTapped() {
        // Given
        let input = viewModelInput(bill: 100, tip: .tenPercent, split: 1)
        let output = sut.transform(input: input)
        let resetCalculatorExpectation = XCTestExpectation(description: "reset calculator called")
        let soundExpectation = audioPlayerService.expectation
        // When
        output.resetCalculatorPublisher.sink { _ in
            resetCalculatorExpectation.fulfill()
        }.store(in: &cancellables)
        
        // Then
        logoViewTapSubject.send()
        wait(for: [resetCalculatorExpectation, soundExpectation], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func viewModelInput(bill: Double, tip: Tip, split: Int) -> CalculatorViewModel.Input {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(),
                     tipPublisher: Just(tip).eraseToAnyPublisher(),
                     splitPublisher: Just(split).eraseToAnyPublisher(),
                     viewTapPublisher: viewTapSubject.eraseToAnyPublisher(),
                     logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
    
}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "playSound has called")
    func playSound() {
        expectation.fulfill()
    }
    
}
