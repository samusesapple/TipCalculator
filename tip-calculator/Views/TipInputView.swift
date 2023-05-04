//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    // MARK: - Properties
    private let headerView: HeaderView = {
       let view = HeaderView()
        view.configureText(topText: "Choose",
                           bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        // 버튼이 눌리면 Tip.tenPercent 값을 tipSubject의 value에 1번만 전달한다.
        button.tapPublisher.flatMap { Just(Tip.tenPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap { Just(Tip.fifteenPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap { Just(Tip.twentyPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellables)
        return button
    }()
    
    private lazy var tipButtonHorizontalStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [tenPercentTipButton,
                                               fifteenPercentTipButton,
                                               twentyPercentTipButton])
        sv.distribution = .fillEqually
        sv.spacing = 16
        return sv
    }()
    
    private lazy var tipButtonVerticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [tipButtonHorizontalStackView,
                                                customTipButton])
        sv.axis = .vertical
        sv.spacing = 16
        sv.distribution = .fillEqually
        return sv
    }()
    
    //
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        setAutolayout()
        observe()
        print(tipSubject.value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    func observe() {
        tipSubject.sink { [unowned self] tip in
            self.resetView()
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                let text = NSMutableAttributedString(string: "$\(value)",
                                                     attributes: [.font: ThemeFont.bold(ofSize: 20)])
                text.addAttributes([.font: ThemeFont.bold(ofSize: 14)],
                                   range: NSMakeRange(0, 1))
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let alert = UIAlertController(title: "Enter custom tip",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Make it generous"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let text = alert.textFields?.first?.text,
                        let value = Int(text) else { return }
                self?.tipSubject.send(.custom(value: value))
            }
            
            [ok, cancel].forEach(alert.addAction(_:))
            return alert
        }()
        parentViewController?.present(alertController, animated: true)
    }
    
    
    // MARK: - Helpers
    private func setAutolayout() {
        [headerView, tipButtonVerticalStackView].forEach(addSubview(_:))
        tipButtonVerticalStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(tipButtonVerticalStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(tipButtonHorizontalStackView.snp.centerY)
        }
    }
    
    private func resetView() {
        [tenPercentTipButton, fifteenPercentTipButton, twentyPercentTipButton, customTipButton].forEach { button in
            button.backgroundColor = ThemeColor.primary
        }
        let text = NSMutableAttributedString(string: "Custom tip",
                                             attributes: [.font: ThemeFont.bold(ofSize: 20)])
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(string: tip.stringValue,
                                             attributes: [.font: ThemeFont.bold(ofSize: 20)])
        text.addAttributes([.font: ThemeFont.demiBold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
    func resetData() {
        tipSubject.send(.none)
    }
    
}
