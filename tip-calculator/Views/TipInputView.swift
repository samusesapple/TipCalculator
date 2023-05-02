//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit

class TipInputView: UIView {
    // MARK: - Properties
    private let headerView: HeaderView = {
       let view = HeaderView()
        view.configureText(topText: "Choose",
                           bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        buildTipButton(tip: .tenPercent)
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        buildTipButton(tip: .fifteenPercent)
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        buildTipButton(tip: .twentyPercent)
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
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
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
