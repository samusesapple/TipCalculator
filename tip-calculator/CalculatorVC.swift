//
//  ViewController.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CalculatorViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2  // 2번 연속으로 탭해야 작동
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [logoView, resultView, billInputView, tipInputView, splitInputView, UIView()])
        sv.axis = .vertical
        sv.spacing = 36
        return sv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setAutolayout()
        bindData()
    }
    
    // MARK: - Data
    private func bindData() {
        let input = CalculatorViewModel.Input(billPublisher: billInputView.valuePublisher,
                                              tipPublisher: tipInputView.valuePublisher,
                                              splitPublisher: splitInputView.valuePublisher,
                                              viewTapPublisher: viewTapPublisher,
                                              logoViewTapPublisher: logoViewTapPublisher)
        let output = viewModel.transform(input: input)
        
        // 계산 결과 resultView에 전달
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }.store(in: &cancellables)
        
        // 키보드 밖 터치되면, 키보드 내리기
        output.resetKeyboardPublisher.sink { [unowned self]_ in
            view.endEditing(true)
        }.store(in: &cancellables)
        
        // 로고 버튼 누르면 리셋 하기
        output.resetCalculatorPublisher.sink { [unowned self] _ in
            billInputView.resetData()
            tipInputView.resetData()
            splitInputView.resetData()
            
            // logoView가 커졌다 작아지는 애니메이션 효과 추가
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           usingSpringWithDamping: 5.0,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseOut) {
                self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.logoView.transform = .identity
                }
            }

        }.store(in: &cancellables)
    }
    
    // MARK: - Helpers
    private func setAutolayout() {
        view.backgroundColor = ThemeColor.background
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }


}

