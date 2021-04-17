import UIKit
import Combine

public class DynamicContent<
        ConfigurationState: DynamicContentState,
        ContentViewType: UIView
>: UIView {
    public var stateSubject: CurrentValueSubject<ConfigurationState, Never>
    public var state: ConfigurationState {
        get { stateSubject.value }
        set { stateSubject.value = newValue }
    }
    private var stateCancellable: AnyCancellable!
    public var content: ContentViewType
    
    private var viewCache: [String : UIView] = [:]
    
    public convenience init(initialState: ConfigurationState, content: (() -> ContentViewType)) {
        self.init(initialState: initialState, content: content())
    }
    
    public init(initialState: ConfigurationState, content: ContentViewType) {
        stateSubject = CurrentValueSubject(initialState)
        self.content = content
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
    
    private func getView(for state: ConfigurationState) -> UIView {
        if let view = viewCache[state.caseDescription] {
            (view as? DynamicContentStateViewBase)?.setup(with: state)
            return view
        }
        let view = state.instantializeView(for: state, contentView: content)
        (view as? DynamicContentStateViewBase)?.setup(with: state)
        viewCache[state.caseDescription] = view
        return view as UIView
    }
    
    private func addContentView(contentView: UIView) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    weak var currentView: UIView?
    private func switchContext(to view: UIView) {
        if content != currentView {
            currentView?.removeFromSuperview()
        }
        currentView = view
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
