//
//  File.swift
//
//
//  Created by Adam Salih on 26.02.2021.
//

import UIKit
import Combine

open class DynamicContent<ConfigurationState: DynamicContentState, ContentViewType: UIView>: UIView {
    public var stateSubject: CurrentValueSubject<ConfigurationState, Never>!
    public var state: ConfigurationState {
        get { stateSubject.value }
        set { stateSubject.value = newValue }
    }
    private var stateCancellable: AnyCancellable!
    public var content: ContentViewType!
    
    private var viewCache: [String : UIView] = [:]
    
    public convenience init(embedIn view: UIView? = nil, initialState: ConfigurationState, content: (() -> ContentViewType)) {
        self.init(embedIn: view, initialState: initialState, content: content())
    }
    
    public init(embedIn view: UIView? = nil, initialState: ConfigurationState, content: ContentViewType) {
        stateSubject = CurrentValueSubject(initialState)
        self.content = content
        super.init(frame: .zero)
        initialSetup()
        if let view = view {
            self.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(self)
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: view.topAnchor),
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func initialSetup() {
        switchContext(to: content)
        stateCancellable = stateSubject
            .compactMap { [weak self] state in self?.getView(for: state) }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] view in self?.switchContext(to: view) }
            )
    }
    
    private func getView(for state: ConfigurationState) -> UIView {
        if let view = viewCache[state.caseDescription] {
            (view as? DCStateViewBase)?.setup(with: state)
            return view
        }
        let view = state.instantializeView(contentView: content)
        (view as? DCStateViewBase)?.setup(with: state)
        viewCache[state.caseDescription] = view
        return view as UIView
    }
    
    weak var currentView: UIView?
    private func switchContext(to view: UIView) {
        if content != currentView {
            currentView?.removeFromSuperview()
        } else {
            content.alpha = 0
        }
        currentView = view
        view.alpha = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
