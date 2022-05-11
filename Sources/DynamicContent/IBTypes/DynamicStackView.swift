//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit
import Combine

open class DynamicStackView: DynamicContent<DynamicContentDefaultState, UIStackView> {
    public init(embedIn view: UIView? = nil, initialState: DynamicContentDefaultState, configuration: ((UIStackView) -> Void)? = nil) {
        let view = UIStackView()
        configuration?(view)
        super.init(embedIn: view, initialState: initialState, content: view)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        content = UIStackView()
        stateSubject = CurrentValueSubject(.content)
        initialSetup()
    }
}
