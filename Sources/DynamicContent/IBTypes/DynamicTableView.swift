//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit

public class DynamicTableView: DynamicContent<DynamicContentDefaultState, UITableView> {
    public init(initialState: DynamicContentDefaultState, configuration: ((UITableView) -> Void)? = nil) {
        let tableView = UITableView()
        configuration?(tableView)
        super.init(initialState: initialState, content: tableView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
