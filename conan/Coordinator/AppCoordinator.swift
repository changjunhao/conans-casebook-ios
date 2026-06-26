//
//  AppCoordinator.swift
//  conan
//
//  Created by iFable on 2025/6/26.
//  Copyright © 2025 iFable. All rights reserved.
//

import UIKit

final class AppCoordinator {

    /// 从指定 VC 弹出案件详情页（模态方式）
    func presentCaseDetail(from presenter: UIViewController, caseBook: CaseBook) {
        let vc = IncidentViewController(id: caseBook.id, incidentService: IncidentService())
        vc.title = caseBook.title
        let nav = UINavigationController(rootViewController: vc)
        presenter.present(nav, animated: true)
    }

    /// 弹出"静候上线"提示
    func showWaitingAlert(from presenter: UIViewController) {
        let alert = UIAlertController(title: nil, message: "静候上线", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        presenter.present(alert, animated: true)
    }

    /// 根据案件状态执行导航：可上线 -> 详情页，未上线 -> 提示
    func navigate(from presenter: UIViewController, caseBook: CaseBook) {
        if caseBook.waiting {
            showWaitingAlert(from: presenter)
        } else {
            presentCaseDetail(from: presenter, caseBook: caseBook)
        }
    }
}
