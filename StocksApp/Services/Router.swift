//
//  Router.swift
//  StocksApp
//
//  Created by Sergio Ramos on 26.12.2021.
//

import UIKit

final class Router {
    
    private var controller: UIViewController?
    private var targetController: UIViewController?
    
    func setRootController(controller: UIViewController) {
        self.controller = controller
    }
    
    func setTargetController(controller: UIViewController) {
        self.targetController = controller
    }
    
    func next() {
        guard let targetController = self.targetController else {
            return
        }
        
        self.controller?.navigationController?.pushViewController(targetController, animated: true)
    }
}
