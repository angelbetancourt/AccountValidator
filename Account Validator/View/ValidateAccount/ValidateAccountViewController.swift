//
//  ValidateAccountViewController.swift
//  Account Validator
//
//  Created by Angel Betancourt on 14/05/21.
//

import UIKit

final class ValidateAccountViewController: UIViewController {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var validateAccountButton: UIButton!
    @IBOutlet weak var showValidationAttemptsButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var passwordHintLabel: UILabel!

    private lazy var presenter: ValidateAccountPresenterProtocol = {
        ValidateAccountPresenterBuilder.build(view: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.handleSceneDidLoad()
    }

    @IBAction func createAccountButtonTouchedUpInside(_ sender: UIButton) {
        presenter.handleCreate(account: .init(username: emailTextField.text ?? "", password: passwordTextField.text ?? ""))
    }

    @IBAction func validateAccountButtonTouchedUpInside(_ sender: UIButton) {
        presenter.handleValidate(account: .init(username: emailTextField.text ?? "", password: passwordTextField.text ?? ""))
    }

    @IBAction func showValidationAttempts(_ sender: UIBarButtonItem) {
    }
}

extension ValidateAccountViewController: ValidateAccountView {

    func display(viewModel: ValidateAccountViewModel) {
        display(validationAttemptsButton: viewModel.showValidationAttemptsButton)

        emailTextField.placeholder = viewModel.usernameTextField.palceholder
        passwordTextField.placeholder = viewModel.passwordTextField.palceholder

        createAccountButton.setTitle(viewModel.createAccountButton.title, for: .normal)
        createAccountButton.isHidden = viewModel.createAccountButton.isHidden

        validateAccountButton.setTitle(viewModel.validateAccountButton.title, for: .normal)
        validateAccountButton.isHidden = viewModel.validateAccountButton.isHidden

        passwordHintLabel.text = viewModel.passwordHint
    }

    func display(validationAttemptsButton: ButtonViewModel) {
        showValidationAttemptsButton.isEnabled = !validationAttemptsButton.isHidden
        showValidationAttemptsButton.title = showValidationAttemptsButton.title
    }

    func display(alert: AlertViewModel) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertController.addAction(.init(title: alert.action.title, style: .default, handler: { _ in alert.action.handler() }))
        present(alertController, animated: true, completion: nil)
    }

    func display(activityIndicator: Bool) {
        if activityIndicator {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

