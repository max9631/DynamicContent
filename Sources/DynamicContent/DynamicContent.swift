import UIKit
import Combine

public protocol ContentState {
}

extension ContentState {
    public var caseDescription: String { String(describing: self).components(separatedBy: "(").first! }
    public var isContent: Bool { caseDescription == "content" }
}

public enum DynamicContentDefaultState: ContentState {
    case loading
    case error(message: String)
    case empty(message: String)
    case content
}

public protocol DynamicContentStateViewBase: UIView {
    func setup(with: ContentState)
}

public protocol DynamicContentStateView: DynamicContentStateViewBase {
    associatedtype StateType: ContentState
    func setup(with: StateType)
}

extension DynamicContentStateView {
    public func setup(with object: ContentState) {
        guard let state = object as? StateType else {
            fatalError("DynamicContent tryied to setup \(String(describing: self)) with \(String(describing: object)), but \(String(describing: self)) only accepts values of type \(String(describing: StateType.self))")
        }
        self.setup(with: state)
    }
}

public class LoadingView: UIView, DynamicContentStateView {
    public func setup(with: DynamicContentDefaultState) {
        
    }
}

public protocol DynamicContentConfiguration {
    associatedtype StateType: ContentState
    
    func getView(for state: StateType, contentView: UIView) -> UIView
}

public class DynamicContentDefaultConfiguration: DynamicContentConfiguration {
    static var shared: DynamicContentDefaultConfiguration = DynamicContentDefaultConfiguration()
    
    public var emptyView: () -> DynamicContentStateViewBase = {
        LoadingView()
    }
    
    public var loadingView: () -> DynamicContentStateViewBase = {
        LoadingView()
    }
    
    public var errorView: () -> DynamicContentStateViewBase = {
        LoadingView()
    }
    
    init() {}
    
    init(emptyView: (() -> DynamicContentStateViewBase)? = nil, loadingView: (() -> DynamicContentStateViewBase)? = nil, errorView: (() -> DynamicContentStateViewBase)? = nil) {
        if let emptyView = emptyView { self.emptyView = emptyView }
        if let loadingView = loadingView { self.loadingView = loadingView }
        if let errorView = errorView { self.errorView = errorView }
    }
    
    public func getView(for state: DynamicContentDefaultState, contentView: UIView) -> UIView {
        switch state {
        case .empty:
            return emptyView()
        case .loading:
            return loadingView()
        case .error:
            return errorView()
        case .content:
            return contentView
        }
    }
}
    

private protocol DynamicContentProtocol {
    associatedtype ConfigurationType: DynamicContentConfiguration
    
    var configuration: ConfigurationType { get }
    var viewCache: [String: DynamicContentStateViewBase] { get }
    
}

public class DynamicContent<
        ConfigurationType: DynamicContentConfiguration,
        ContentViewType: UIView
>: UIView, DynamicContentProtocol {
    
//    public var state: PassthroughSubject<ConfigurationType.StateType, Never>
    public var stateSubject: CurrentValueSubject<ConfigurationType.StateType, Never>
    public var state: ConfigurationType.StateType {
        get { stateSubject.value }
        set { stateSubject.value = newValue }
    }
    private var stateCancellable: AnyCancellable!
    public var content: ContentViewType
    
    fileprivate var configuration: ConfigurationType
    fileprivate var viewCache: [String : DynamicContentStateViewBase] = [:]
    
    public convenience init(configuration: ConfigurationType, initialState: ConfigurationType.StateType, content: (() -> ContentViewType)) {
        self.init(configuration: configuration, initialState: initialState, content: content())
    }
    
    public init(configuration: ConfigurationType, initialState: ConfigurationType.StateType, content: ContentViewType) {
        stateSubject = CurrentValueSubject(initialState)
        self.content = content
        self.configuration = configuration
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addContentView(contentView: content)
        stateCancellable = stateSubject
            .compactMap { [weak self] state in self?.getView(for: state) }
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] view in self?.switchContext(to: view) }
            )
    }
    
    private func getView(for state: ConfigurationType.StateType) -> UIView {
        if state.isContent {
            return content
        }
        if let view = viewCache[state.caseDescription] {
            return view
        }
        let view = configuration.getView(for: state, contentView: content)
        (view as? DynamicContentStateViewBase)?.setup(with: state)
        viewCache[state.caseDescription] = view
        return view as UIView
    }
    
    private func addContentView(contentView: UIView) {
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: self.topAnchor),
            content.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    weak var currentView: UIView?
    private func switchContext(to view: UIView) {
        currentView?.removeFromSuperview()
        currentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: self.topAnchor),
            content.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

public extension DynamicContent where ConfigurationType == DynamicContentDefaultConfiguration {
    convenience init(initialState: DynamicContentDefaultState, content: (() -> ContentViewType)) {
        self.init(configuration: DynamicContentDefaultConfiguration(), initialState: initialState, content: content())
    }
    convenience init(initialState: DynamicContentDefaultState, content: ContentViewType) {
        self.init(configuration: DynamicContentDefaultConfiguration(), initialState: initialState, content: content)
    }
}





