//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    
    private var viewModel: FeedVMProtocol
    
    init(viewModel: FeedVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    var routeToPost: (Post) -> () = {_ in }
    
    var routeToAudiu: () -> () = {}
    
    var routeToVideo: () -> () = {}
    
    var routeToRecord: () -> () = {}
    
    var routeToMap: () -> () = {}
    
    var switchToLoginInterface: (() -> ())? = nil
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    private lazy var buttonOne: CustomButton = {
        let button = CustomButton(title: "Open post".localized, titleColor: .systemBlue){
            self.viewModel.fetchPost()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonTwo: CustomButton = {
        let button = CustomButton(title: "Open post".localized + " 2", titleColor: .systemBlue){
            self.viewModel.signOut()
            self.switchToLoginInterface?()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var buttonAudio: CustomButton = {
        let button = CustomButton(title: "Open audio".localized, titleColor: .systemBlue){
            self.routeToAudiu()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var buttonVideo: CustomButton = {
        let button = CustomButton(title: "Open video".localized, titleColor: .systemBlue){
            self.routeToVideo()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonRecord: CustomButton = {
        let button = CustomButton(title: "Open entry".localized, titleColor: .systemBlue){
            self.routeToRecord()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonMap: CustomButton = {
        let button = CustomButton(title: "Open Map".localized, titleColor: .systemBlue){
            self.routeToMap()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var checkGuessTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check Guess", titleColor: .white){
            if(self.checkGuessTextField.text != nil){
                self.viewModel.check(input: self.checkGuessTextField.text!)
            }
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        return button
    }()
    
    private lazy var checkGuessLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    
    
    private lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.addArrangedSubview(self.buttonOne)
        stackView.addArrangedSubview(self.buttonTwo)
        stackView.addArrangedSubview(self.buttonAudio)
        stackView.addArrangedSubview(self.buttonVideo)
        stackView.addArrangedSubview(self.buttonRecord)
        stackView.addArrangedSubview(self.buttonMap)
        stackView.backgroundColor =  .customBackgroundColor
        stackView.addArrangedSubview(self.checkGuessTextField)
        stackView.addArrangedSubview(self.checkGuessButton)
        stackView.addArrangedSubview(self.checkGuessLabel)
        
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        setupContraints()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.currentState = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .initial:
                print("initial")
            case .loading:
                activityIndicator.isHidden = false
                stackView.isHidden = true
                activityIndicator.startAnimating()
            case .loadedPost(let post):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    stackView.isHidden = false
                    routeToPostViewController(post: post)
                }
            case .error:
                print("error")
            case .loadedCheck(let isSuccess):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                    stackView.isHidden = false
                    if(isSuccess){
                        self.checkGuessLabel.textColor = .green
                        self.checkGuessLabel.text = "success"
                    }else{
                        self.checkGuessLabel.textColor = .red
                        self.checkGuessLabel.text = "failed"
                    }
                }
            }
        }
    }
    
    func setupContraints(){
        let safeAreaGuide = view.safeAreaLayoutGuide
        let constraint = [
            stackView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    func routeToPostViewController(post: Post) {
        routeToPost(post)
    }
    
}
