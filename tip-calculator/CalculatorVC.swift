//
//  ViewController.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit
import SnapKit
import Combine

class CalculatorVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel = CalculatorViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        let input = CalculatorViewModel.Input(billPublisher: billInputView.valuePublisher, tipPublisher: tipInputView.valuePublisher, splitPublisher: Just(2).eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
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

