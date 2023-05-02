//
//  HeaderView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    private let topLabel: UILabel = {
        LabelFactory.build(
            text: nil,
            font: ThemeFont.bold(ofSize: 18))
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(
            text: nil,
            font: ThemeFont.regular(ofSize: 16))
    }()
    
    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [topSpacerView,
                                                topLabel,
                                                bottomLabel,
                                                bottomSpacerView
                                               ])
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = -4
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
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        topSpacerView.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacerView)
        }
    }
    
    func configureText(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
    
    
}
