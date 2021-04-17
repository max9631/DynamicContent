//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public protocol DynamicContentState {
    func instantializeView(for state: Self, contentView: UIView) -> UIView
}

extension DynamicContentState {
    public var caseDescription: String { String(describing: self).components(separatedBy: "(").first! }
}

public enum DynamicContentDefaultState: DynamicContentState {
    
    public static var emptyView: () -> DynamicContentStateViewBase = {
        EmptyView()
    }
    
    public static var loadingView: () -> DynamicContentStateViewBase = {
        LoadingView()
    }
    
    public static var errorView: () -> DynamicContentStateViewBase = {
        ErrorView()
    }
    
    case loading
    case error(message: String, action: () -> Void)
    case empty(message: String)
    case content
    
    public func instantializeView(for state: DynamicContentDefaultState, contentView: UIView) -> UIView {
        switch state {
        case .empty:
            return DynamicContentDefaultState.emptyView()
        case .loading:
            return DynamicContentDefaultState.loadingView()
        case .error:
            return DynamicContentDefaultState.errorView()
        case .content:
            return contentView
        }
    }
}
