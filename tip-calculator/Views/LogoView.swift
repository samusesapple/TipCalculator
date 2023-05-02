//
//  LogoView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit

class LogoView: UIView {
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "icCalculatorBW"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "My TIP",
                                             attributes: [.font: ThemeFont.demiBold(ofSize: 16)])
        // Mr TIP 중 TIP 3 글자만 크게 attributes 생성하기 - NSMakeRange로 'Mr '(3글자) 이후 3글자에 attribute주도록 range설정
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)],
                           range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(text: "Calculator",
                           font: ThemeFont.demiBold(ofSize: 20),
                           textAlignment: .left)
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topLabel,
                                                  bottomLabel])
        view.axis = .vertical
        view.spacing = -4
        return view
    }()
    
    private lazy var finalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView,
                                                  verticalStackView])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
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
        addSubview(finalStackView)
        
        finalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
}




