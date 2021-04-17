//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public protocol DynamicContentStateViewBase: UIView {
    func setup(with: Any)
}

public protocol DynamicContentStateView: DynamicContentStateViewBase {
    associatedtype StateType: DynamicContentState
    func setup(with: StateType)
}

extension DynamicContentStateView {
    public func setup(with object: Any) {
        guard let state = object as? StateType else {
            fatalError("DynamicContent tryied to setup \(String(describing: self)) with \(String(describing: object)), but \(String(describing: self)) only accepts values of type \(String(describing: StateType.self))")
        }
        self.setup(with: state)
    }
}
