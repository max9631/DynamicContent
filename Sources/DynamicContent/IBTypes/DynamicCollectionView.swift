//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit
import Combine

open class DynamicCollectionView: DynamicContent<DynamicContentDefaultState, UICollectionView> {
    public init(embedIn view: UIView? = nil, initialState: DynamicContentDefaultState, configuration: ((UICollectionView) -> Void)? = nil) {
        let tableView = UICollectionView()
        configuration?(tableView)
        super.init(embedIn: view, initialState: initialState, content: tableView)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        content = UICollectionView()
        stateSubject = CurrentValueSubject(.content)
        initialSetup()
    }
}
