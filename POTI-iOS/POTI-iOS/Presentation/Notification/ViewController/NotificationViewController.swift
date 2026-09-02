//
//  NotificationViewController.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import Combine

final class NotificationViewController: BaseViewController<NotificationViewModel>, NavigationConfigurable {

    // MARK: - Properties

    private let rootView = NotificationView()
    private let factory: ViewControllerFactory
    private lazy var deepLinkRouter = DeepLinkRouter(factory: factory)

    // MARK: - Initializer

    init(viewModel: NotificationViewModel, factory: ViewControllerFactory) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycles

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.viewDidLoad)
    }

    // MARK: - Custom Methods

    override func setDelegate() {
        rootView.notificationTableView.dataSource = self
        rootView.notificationTableView.delegate = self
    }

    override func addTarget() {
        rootView.readAllButton.addTarget(self, action: #selector(readAllButtonTapped), for: .touchUpInside)
    }

    override func bindViewModel() {
        viewModel.output.reloadData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                rootView.updateEmptyState(isEmpty: viewModel.notifications.isEmpty)
                rootView.updateReadAllButton(isEnabled: viewModel.hasUnreadNotification)
                rootView.notificationTableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.output.deepLink
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.openDeepLink($0) }
            .store(in: &cancellables)
    }

    override func settingButtonTapped() {
        let notificationSettingViewController = factory.makeNotificationSettingViewController()
        navigationController?.pushViewController(notificationSettingViewController, animated: true)
    }

    // MARK: - Private Method

    private func openDeepLink(_ deepLink: String) {
        do {
            guard let url = URL(string: deepLink) else { return }
            let parser = DeepLinkParser(allowedHost: try AppConfig.deepLinkHost())
            guard let route = parser.parse(url) else { return }

            guard let navigationController else {
                deepLinkRouter.route(to: route, from: view.window?.rootViewController)
                return
            }

            let destinationViewController = deepLinkRouter.makeViewController(for: route)
            destinationViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(destinationViewController, animated: true)
        } catch {
            PotiLogger.error(error)
        }
    }
    
    // MARK: - Public Method

    func navigationStyle() -> PotiNavigationStyle {
        .notification
    }

    // MARK: - Action

    @objc private func readAllButtonTapped() {
        viewModel.action(.didTapReadAll)
    }
}

// MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier, for: indexPath) as? NotificationCell else {
            return UITableViewCell()
        }

        let notification = viewModel.notifications[indexPath.row]
        cell.configure(title: notification.title, content: notification.content, time: notification.time, isRead: notification.isRead)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.action(.didTapNotification(index: indexPath.row))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 100
        guard scrollView.contentOffset.y > threshold else { return }
        viewModel.action(.loadNextPage)
    }
}
