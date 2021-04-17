//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class ErrorView: UIView, DynamicContentStateViewBase {
    private lazy var imageView: UIImageView = createImageView()
    private lazy var messageLabel: UILabel = createMessageLabel()
    private lazy var button: UIButton = createButton()
    
    private var action: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        [imageView, messageLabel, button].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(view)
        }
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
            button.trailingAnchor.constraint(greaterThanOrEqualTo: container.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func createMessageLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    private func createImageView() -> UIImageView {
        let image = UIImageView()
        return image
    }
    
    private func createButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }
    
    @objc func handleButtonTap() {
        action?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    public func setup(with state: Any) {
        guard let state = state as? DynamicContentDefaultState,
            case let .error(message, action) = state else {
            return
        }
        messageLabel.text = message
        self.action = action
    }
}
