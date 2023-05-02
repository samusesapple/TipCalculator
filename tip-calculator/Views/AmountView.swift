//
//  AmountView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit

class AmountView: UIView {
    
    // MARK: - Properties
    private let title: String
    private let textAlignment: NSTextAlignment
    
    private lazy var titleLabel: UILabel = {
        LabelFactory.build(text: title,
                           font: ThemeFont.regular(ofSize: 18),
                           textColor: ThemeColor.text,
                           textAlignment: textAlignment)
    }()
    
    private lazy var amountLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = textAlignment
        label.textColor = ThemeColor.primary
        let text = NSMutableAttributedString(string: "$0",
                                             attributes: [.font: ThemeFont.bold(ofSize: 24)])
        text.addAttributes([.font: ThemeFont.bold(ofSize: 16)],
                           range: NSMakeRange(0, 1))
        label.attributedText = text
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel,
                                                amountLabel])
        sv.axis = .vertical
        return sv
    }()
    
    
    // MARK: - Lifecycle
    init(title: String, textAlignment: NSTextAlignment) {
        self.title = title
        self.textAlignment = textAlignment
        super.init(frame: .zero)
        setAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    private func setAutolayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
