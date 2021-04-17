//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class DynamicStackView: DynamicContent<DynamicContentDefaultState, UIStackView> {
    public init(initialState: DynamicContentDefaultState, configuration: ((UIStackView) -> Void)? = nil) {
        let view = UIStackView()
        configuration?(view)
        super.init(initialState: initialState, content: view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
