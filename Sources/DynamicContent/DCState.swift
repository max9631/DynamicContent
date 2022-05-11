//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public protocol DynamicContentState {
    func instantializeView(contentView: UIView) -> UIView
}

extension DynamicContentState {
    public var caseDescription: String { String(describing: self).components(separatedBy: "(").first! }
}

public enum DynamicContentDefaultState: DynamicContentState {
    
    public static var emptyView: () -> DCStateViewBase = {
        DCEmptyView()
    }
    
    public static var loadingView: () -> DCStateViewBase = {
        DCLoadingView()
    }
    
    public static var errorView: () -> DCStateViewBase = {
        DCErrorView()
    }
    
    case loading
    case error(message: String, action: () -> Void)
    case empty(message: String)
    case content
    
    public func instantializeView(contentView: UIView) -> UIView {
        switch self {
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
