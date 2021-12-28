//
//  DialogManager.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

protocol IDialogManager {
    func setController(controller: UIViewController)
    func showErrorDialog(title: String?, message: String?)
}

final class DialogManager {
    
    private weak var controller: UIViewController?
}

extension DialogManager: IDialogManager {
    
    func setController(controller: UIViewController) {
        self.controller = controller
    }
    
    func showErrorDialog(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.controller?.present(alert, animated: true)
    }
}

