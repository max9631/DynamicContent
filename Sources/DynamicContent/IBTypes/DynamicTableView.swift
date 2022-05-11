//
//  File.swift
//  
//
//  Created by Adam Salih on 17.04.2021.
//

import UIKit
import Combine

open class DynamicTableView: DynamicContent<DynamicContentDefaultState, UITableView> {
    public init(embedIn view: UIView? = nil, initialState: DynamicContentDefaultState, configuration: ((UITableView) -> Void)? = nil) {
        let tableView = UITableView()
        configuration?(tableView)
        super.init(embedIn: view, initialState: initialState, content: tableView)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        content = UITableView()
        stateSubject = CurrentValueSubject(.content)
        initialSetup()
    }
}
