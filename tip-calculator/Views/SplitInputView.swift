//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    // MARK: - Properties
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configureText(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        // min X -> 왼쪽 다 깎기
        let button = buildButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.tapPublisher.flatMap {[unowned self] _ in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        // max X -> 오른쪽 다 깎기
    let button = buildButton(text: "+", corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        button.tapPublisher.flatMap {[unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
    return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(text: "1",
                                       font: ThemeFont.bold(ofSize: 20),
                                       backgroundColor: .white)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [decrementButton,
                                                quantityLabel,
                                                incrementButton])
        sv.spacing = 0
        return sv
    }()
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        setAutolayout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    private func observe() {
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = String(quantity)
        }.store(in: &cancellables)
    }
    
    // MARK: - Helpers
    private func setAutolayout() {
        [headerView, stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton,decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
    private func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = ThemeFont.bold(ofSize: 25)
        button.addRoundedCorners(corners: corners, radius: 8.0)
        button.backgroundColor = ThemeColor.primary
        return button
    }
    
    func resetData() {
        splitSubject.send(1)
    }
}
