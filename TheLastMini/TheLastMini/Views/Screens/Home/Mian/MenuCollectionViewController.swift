//
//  MenuCollectionViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 25/07/24.
//

import UIKit

class MenuCollectionViewController: UICollectionViewController {

    private lazy var menuColletion: MenuColletionView = {
        let view = MenuColletionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        self.view = menuColletion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewCode()
        setupCells()
    }

}


extension MenuCollectionViewController: ViewCode{
    func addViews() {
        self.menuColletion.delegate = self
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            menuColletion.topAnchor.constraint(equalTo: view.topAnchor),
            menuColletion.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuColletion.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuColletion.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStyle() {

    }
    
    func setupCells(){
        let model: [MenuDataModel] = [MenuDataModel(image: UIImage(resource: .interlagos), text: "Interlagos"),
                                      MenuDataModel(image: UIImage(resource: .r34), text: "Interlagos"),
                                      MenuDataModel(image: UIImage(resource: .r34), text: "Interlagos")]
        self.menuColletion.configure(model)
    }
}

extension MenuCollectionViewController: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        switch tag{
        case 0:
            navigationController?.pushViewController(GamePlayViewController(), animated: true)
        default:
            print("tag Invalida")
        }
    }
}