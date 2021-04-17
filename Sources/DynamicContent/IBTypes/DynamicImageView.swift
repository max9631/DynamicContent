//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit
import Combine

open class DynamicImageView: DynamicContent<DynamicContentDefaultState, UIImageView> {
    public init(embedIn view: UIView? = nil, initialState: DynamicContentDefaultState, configuration: ((UIImageView) -> Void)? = nil) {
        let view = UIImageView()
        configuration?(view)
        super.init(embedIn: view, initialState: initialState, content: view)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        content = UIImageView()
        stateSubject = CurrentValueSubject(.content)
        initialSetup()
    }
}
