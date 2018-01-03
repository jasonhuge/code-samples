//
//  ADAlertController.swift
//
//  Created by Jason Hughes on 10/27/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit


/// Modal Styles that can be used
///
/// - overlay: has a 20px margin around the content exposing the presenting viewControllers view.
/// - full: has no margin around content.
/// - partial: has a 20px margin on left and right and allows the content to expand and contract vertically.  Maxes out at 20px from the bottom and top.
enum ADAlertControllerModalStyle {
    case overlay
    case full
    case partial
}

class ADAlertController: UIViewController {
    
    struct ADAlertControllerConstants {
        static let backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        static let buttonStackViewMarginBottom: CGFloat = 30;
        
        // button values
        static let buttonHeight: CGFloat = 50
        static let buttonVerticalSpacing: CGFloat = 15
        static let buttonLeftRightPadding: CGFloat = 50
        static let buttonTitleEdgeInsets: CGFloat = 15
        
        //Nibs for default content styles
        static let overlayModalStyleContentID = "ADAlertOverlayViewContent"
        static let fullModalStyleContentID = "ADAlertFullContentView"
        static let partialModalStyleContentID = "ADAlertPartialContentView"
    }

    /// Container for both content and buttons
    public let containerView = UIView()

    /// Container for alertTitle, alertMessage, alertImage
    private let contentContainerView = UIView()
    
    /// Container for all buttons
    private let buttonStackView = UIStackView()
    
    private let modalStyle: ADAlertControllerModalStyle
    
    private var alertTitle :String?
    private var alertMessage: String?
    private var alertImage: UIImage?
    
    private var actions = [ADAlertAction]()
    private var selectedAction:ADAlertAction?
    
    private var contentNibName: String?
    
    // MARK: - Initializers
    
    
    /// Initializes the ViewController
    ///
    /// - Parameters:
    ///   - modalStyle: ADAlertControllerModalStyle to be used for presentation
    ///   - title: optional title to be used for alert
    ///   - message: optional message to be used for alert
    ///   - image: optional image to be used for alert
    init(modalStyle:ADAlertControllerModalStyle, title:String?, message:String?, image:UIImage?) {
        
        self.modalStyle = modalStyle
        self.alertTitle = title
        self.alertMessage = message
        self.alertImage = image
        
        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = self
        self.modalPresentationStyle = .custom
        
    }
    
    
    /// Initializes the ViewController
    ///
    /// - Parameters:
    ///   - modalStyle: ADAlertControllerModalStyle to be used for presentation
    ///   - title: optional title to be used for alert
    ///   - message: optional message to be used for alert
    ///   - image: optional image to be used for alert
    ///   - contentNibName: optional nib name if custom layout for title message and image is required
    convenience init(modalStyle:ADAlertControllerModalStyle, title:String?, message:String?, image:UIImage?, contentNibName:String?) {
        self.init(modalStyle: modalStyle, title: title, message: message, image: image)
        
        self.contentNibName = contentNibName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBackground()
        
        // setup views
        self.setupContainerView()
        self.setupContentContainerView()
        self.setupButtonStackView()
        
        //layout view constraints
        self.layoutContainerView()
        self.layoutContentContainerView()
        self.layoutButtonView()
        
        // layout any constraints that are interdependant
        self.layoutDependantConstraints()
        
        // set up the view that contains the title, message and image
        self.setupModalContent();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.buttonStackView.arrangedSubviews.count == 0 {
            self.setupActions()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.transitioningDelegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Setup
    private func setupBackground() {
        switch self.modalStyle {
        case .full:
            self.view.backgroundColor = .white
        default:
            self.view.backgroundColor = ADAlertControllerConstants.backgroundColor
        }
    }
    
    
    /// sets up the container view and adds it to the view
    private func setupContainerView() {
        self.view.addSubview(self.containerView)
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.backgroundColor = .white
        
    }
    
    /// sets up the content container view and adds it to the view
    private func setupContentContainerView() {
        self.containerView.addSubview(self.contentContainerView)
        self.contentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    /// sets up the button stack view and adds it to the view
    private func setupButtonStackView() {
        
        self.buttonStackView.alignment = .center
        self.buttonStackView.distribution = .fill
        self.buttonStackView.spacing = ADAlertControllerConstants.buttonVerticalSpacing
        self.buttonStackView.axis = .vertical
        
        self.containerView.addSubview(self.buttonStackView)
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    /// sets up the content.  This will be a view that includes a title, message and or image.  The view will then
    /// be added to the contentContainerView, layed out and updated
    private func setupModalContent() {
        
        guard let contentView = self.contentView(forModalStyle: self.modalStyle) else {
            return
        }
        
        self.contentContainerView.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.topAnchor.constraint(equalTo: self.contentContainerView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.contentContainerView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.contentContainerView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.contentContainerView.bottomAnchor).isActive = true
        
        contentView.update(withTitle: self.alertTitle, message: self.alertMessage, image: self.alertImage)
        
    }
    
    
    /// sets up the actions that were added to the alertController via the add function
    private func setupActions() {
    
        self.sortActions()
        
        for action in self.actions {

            let button = self.button(forAction: action)
            
            self.buttonStackView.addArrangedSubview(button)
            
            button.leftAnchor.constraint(equalTo: self.buttonStackView.leftAnchor, constant: ADAlertControllerConstants.buttonLeftRightPadding).isActive = true
            button.rightAnchor.constraint(equalTo: self.buttonStackView.rightAnchor, constant: -ADAlertControllerConstants.buttonLeftRightPadding).isActive = true
            
            button.addTarget(self, action: #selector(self.on(actionButtonTapped:)), for: .touchUpInside)
        
        }
    }
    
    // MARK: - Layout
    private func layoutContainerView() {
        if self.containerView.superview != nil {
            switch self.modalStyle {
            case .full:
                self.layoutContainerViewForFullModalStyle()
                
            case .partial:
                self.layoutContainerViewForPartialModalStyle()
                
            default:
                
                self.layoutContainerViewForOverlayModalStyle()
                
            }
        }
    }
    
    private func layoutContentContainerView() {
        if self.contentContainerView.superview != nil {
            self.contentContainerView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
            self.contentContainerView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
            self.contentContainerView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
        }
    }
    
    private func layoutButtonView() {
        if self.buttonStackView.superview != nil {
            let marginBottom = ADAlertControllerConstants.buttonStackViewMarginBottom
            
            self.buttonStackView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor).isActive = true
            self.buttonStackView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor).isActive = true
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -marginBottom).isActive = true
            
        }
    }
    
    
    /// sets up constraints that are interdependant between the contentContainerView and the buttonStackView
    private func layoutDependantConstraints() {
        
        self.buttonStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(kCompassButtonHeightLarge)).isActive = true
        
        switch self.modalStyle {
        case .partial:
            self.contentContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
            self.buttonStackView.topAnchor.constraint(equalTo: self.contentContainerView.bottomAnchor).isActive = true
        default:
            
            self.contentContainerView.bottomAnchor.constraint(equalTo: self.buttonStackView.topAnchor).isActive = true
        }
    }
    
    //MARK - Event Actions
    
    /// on button tap sets the selected action calls the handler an dismisses the modal if should dismis is set to true
    /// in the selected action
    ///
    /// - Parameter button: action button tapped - should contain a tag that corisponds to a action.tag
    @objc private func on(actionButtonTapped button:UIButton) {
        var shouldDismiss = true
        
        guard let selectedAction = self.action(forTag: button.tag) else {
            return
        }
        
        self.selectedAction = selectedAction
        
        shouldDismiss = selectedAction.shouldDismiss
        
        if shouldDismiss {
            self.dismiss(animated: true, completion: {
                self.callHandler(forAction: selectedAction)
            })
        } else {
            self.callHandler(forAction: selectedAction)
        }
    }

    //MARK - Convenience
    private func callHandler(forAction action:ADAlertAction) {
        if let handler = action.handler {
            handler(action)
        }
    }
    
    
    /// returns a action from the actions array with a tag that matches the tag passed in
    ///
    /// - Parameter tag: Int value used to find a action in the action array
    /// - Returns: returns a action that contains the same value tag as the passed in value
    private func action( forTag tag:Int) ->ADAlertAction? {
        let selectedActions = self.actions.filter { (action) -> Bool in
            if action.tag == tag {
                return true
            }
            
            return false
        }
        
        var action:ADAlertAction?
        
        if let selectedAction = selectedActions.first {
            action = selectedAction
        }
        
        return action
    }
    
    /// Sorts the actions by tag if they are of the same type or by type if their types differ
    private func sortActions() {
        self.actions = self.actions.sorted(by: { (firstAction, secondAction) -> Bool in
            let firstActionStyle = firstAction.style
            let secondActionStyle = secondAction.style
            
            if firstActionStyle.hashValue == secondActionStyle.hashValue {
                if firstAction.tag < secondAction.tag {
                    return true
                }
            } else {
                if firstActionStyle.hashValue > secondActionStyle.hashValue {
                    return true
                }
            }
            
            return false
        })
    }
    
    
    /// returns content that has the same nib identifier as the one passed in
    ///
    /// - Parameter modalStyleContentIdentifier: nib name
    /// - Returns: ADAlertContentView that contains the title, message and image.
    private func contentView( forModalStyleContentIdentifier modalStyleContentIdentifier: String) ->ADAlertContentView? {
        return Bundle.main.loadNibNamed(modalStyleContentIdentifier, owner: nil, options: nil)?.first as? ADAlertContentView
    }
    
    
    /// returns a contentView for the modalStyle passed in. One note if the class property contentNibName is set we try
    /// and return a view for that ID
    ///
    /// - Parameter modalStyle: ADAlertControllerModalStyle to be used
    /// - Returns: ADAlertContentView that contains the title, message and image.
    private func contentView( forModalStyle modalStyle:ADAlertControllerModalStyle) ->ADAlertContentView? {
        
        var contentIndentifier = self.contentNibName
        
        if contentIndentifier == nil {
            switch modalStyle {
            case .full:
                contentIndentifier = ADAlertControllerConstants.fullModalStyleContentID
            case .partial:
                contentIndentifier = ADAlertControllerConstants.partialModalStyleContentID
            default:
                contentIndentifier = ADAlertControllerConstants.overlayModalStyleContentID
            }
        }

        guard let unwrappedContentIndentifier = contentIndentifier,  let contentView = self.contentView(forModalStyleContentIdentifier: unwrappedContentIndentifier) else {
            return nil
        }
        
        return contentView
    }
    
    
    /// Creates a CompassButton for the action passed in
    ///
    /// - Parameter action: ADAlertAction used to polulate the button and set it's style
    /// - Returns: Compass button
    private func button(forAction action:ADAlertAction) ->CompassButton {
        let button = CompassButton(type: .custom)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleEdgeInsets = UIEdgeInsetsMake(0, ADAlertControllerConstants.buttonTitleEdgeInsets, 0, ADAlertControllerConstants.buttonTitleEdgeInsets)
        button.accessibilityIdentifier = "ADAlertViewButton"
        button.tag = Int(action.tag)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: ADAlertControllerConstants.buttonHeight).isActive = true
        
        switch action.style {
        case .primary:
            button.style = CompassButtonStylePrimary
        case .secondary:
            button.style = CompassButtonStyleSecondary
        default:
            button.style = CompassButtonStyleNoBorder
        }
        
        button.setTitle(action.title, for: .normal)
        
        return button
    }
    
    
    /// Adds a action the the actions array. It's worth noting we are only allowing three actions to be added
    ///
    /// - Parameter action: action to be added
    public func add(action:ADAlertAction) {
        if self.actions.count < 3 {
            action.tag = self.actions.count
            self.actions.append(action)
        } else {
            assertionFailure("Attepmt to add more than 3 ADAlertActions to ADAlertViewController")
        }
    }
    
}


// MARK: - Overlay Modal Functions
extension ADAlertController {
    
    private func layoutContainerViewForOverlayModalStyle() {
        let margin:CGFloat = 20.0
        
        if #available(iOS 11.0, *)  {
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant:margin).isActive = true
            self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant:-margin).isActive = true
        } else {
            self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant:margin).isActive = true
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant:-margin).isActive = true
        }
        
        self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:margin).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true
    }

}

// MARK: - Full Modal
extension ADAlertController {
    private func layoutContainerViewForFullModalStyle() {
        self.containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

}

// MARK: - Partial Modal
extension ADAlertController {
    private func layoutContainerViewForPartialModalStyle() {
        let margin:CGFloat = 20.0
        
        self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        self.containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant:margin).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true
    
    }
 
}

// MARK: - UIViewControllerTransitioningDelegate
extension ADAlertController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ADAlertControllerTransitionAnimatorForPresenting()
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = ADAlertControllerTransitionAnimatorForDismissing()
        
        return animator
    }
    
}



