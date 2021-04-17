//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class DCLoadingView: UIView, DCStateViewBase {
    private lazy var activityIndicator: UIActivityIndicatorView = createActivityIndicator()
    private lazy var messageLabel: UILabel = createMessageLabel()
    
    public init(message: String = "Loading...") {
        super.init(frame: .zero)
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(activityIndicator)
        messageLabel.text = message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            container.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: container.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 32),
            messageLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func createMessageLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        return indicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        activityIndicator.stopAnimating()
    }
    
    public func setup(with state: Any) {
        activityIndicator.startAnimating()
    }
}
