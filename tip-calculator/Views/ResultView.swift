//
//  ResultView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit

class ResultView: UIView {
    
    // MARK: - Properties
    private let headerLabel: UILabel = {
        LabelFactory.build(text: "Total p/person",
                           font: ThemeFont.demiBold(ofSize: 18))
    }()
    
    private let amountPerPersonLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        let text = NSMutableAttributedString(string: "$0",
                                             attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)],
                           range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [AmountView(title: "Total bill", textAlignment: .left), UIView(), AmountView(title: "Total tip", textAlignment: .right)])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var finalStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [headerLabel,
                                               amountPerPersonLabel,
                                               horizontalLineView,
                                               buildSpacerView(height: 0),
                                               horizontalStackView])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setAutolayout()
        addShadow(offset: CGSize(width: 0, height: 3),
                  color: .black,
                  radius: 12.0,
                  opacity: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(result: Result) {
        let text = NSMutableAttributedString(string: result.amountPerPerson.currencyFormatted,
                                             attributes: [.font: ThemeFont.bold(ofSize: 48)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)],
                           range: NSMakeRange(0, 1))
        amountPerPersonLabel.attributedText = text
        
        let totalBillView = horizontalStackView.subviews[0] as! AmountView
        totalBillView.configure(amount: result.totalBill)
        let totalTipView = horizontalStackView.subviews.last as! AmountView
        totalTipView.configure(amount: result.totalTip)
    }
    // MARK: - Helpers
    private func setAutolayout() {
        addSubview(finalStackView)
        finalStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return view
    }
}

