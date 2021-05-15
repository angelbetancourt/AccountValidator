//
//  ValidationAttemptsViewController.swift
//  Account Validator
//
//  Created by Angel Betancourt on 15/05/21.
//

import UIKit

final class ValidationAttemptsViewController: UITableViewController {

    private lazy var presenter: ValidationAttemptsPresenterProtocol = {
        ValidationAttemptsPresenterBuilder.build(view: self)
    }()

    private var viewModels = [ValidationAttemptViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.handleSceneDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ValidationAttemptTableViewCell", for: indexPath)

        let viewModel = viewModels[indexPath.row]
        cell.textLabel?.text = viewModel.title
        cell.detailTextLabel?.text = viewModel.subtitle

        return cell
    }
}

extension ValidationAttemptsViewController: ValidationAttemptsView {
    func display(validationAttempts: [ValidationAttemptViewModel]) {
        viewModels = validationAttempts
        tableView.reloadData()
    }
}
