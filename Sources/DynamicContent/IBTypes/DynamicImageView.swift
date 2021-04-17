//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class DynamicImageView: DynamicContent<DynamicContentDefaultState, UIImageView> {
    public init(initialState: DynamicContentDefaultState, configuration: ((UIImageView) -> Void)? = nil) {
        let view = UIImageView()
        configuration?(view)
        super.init(initialState: initialState, content: view)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
