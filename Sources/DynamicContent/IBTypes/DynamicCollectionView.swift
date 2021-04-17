//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class DynamicCollectionView: DynamicContent<DynamicContentDefaultState, UICollectionView> {
    public init(initialState: DynamicContentDefaultState, configuration: ((UICollectionView) -> Void)? = nil) {
        let tableView = UICollectionView()
        configuration?(tableView)
        super.init(initialState: initialState, content: tableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
