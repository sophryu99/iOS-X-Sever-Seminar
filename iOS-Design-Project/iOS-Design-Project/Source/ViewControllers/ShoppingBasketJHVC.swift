//
//  ShoppingBasketJHVC.swift
//  iOS-Design-Project
//
//  Created by 이주혁 on 2020/05/27.
//  Copyright © 2020 이주혁. All rights reserved.
//

import UIKit

class ShoppingBasketJHVC: UIViewController {


    //MARK: Normal Property
    var selectedTab: SelectedTapInShoppingCart = .normalPurchase
    var rocketFreshProductList: [ProductJH] = []
    var rocketDeliveryProductList: [ProductJH] = []
    var normalProductList: [ProductJH] = []
    
    var itemCount: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setDummy()
        //self.tableViewHeight.constant = 0

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Custom Method
    func setDummy(){
        self.rocketFreshProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketFreshProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketFreshProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketFreshProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketDeliveryProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketDeliveryProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.rocketDeliveryProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.normalProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.normalProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.normalProductList.append(ProductJH(category: .rocketDelivery, name: "123", imgStr: "123", priceStr: "!23"))
        self.itemCount = self.rocketDeliveryProductList.count + self.rocketFreshProductList.count + self.normalProductList.count
    }

    
    @IBAction func touchUpBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension TableView
extension ShoppingBasketJHVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowNum: Int = 0
        switch section {
        case 0:
            rowNum = self.rocketFreshProductList.count
        case 1:
            rowNum = self.rocketDeliveryProductList.count
        case 2:
            rowNum = self.normalProductList.count
            
        default:
            break
        }
        
        return rowNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductInShoppingBasketCell.identifier) as? ProductInShoppingBasketCell else {
            return UITableViewCell()
        }
        return cell
    }
    
}

// MARK:- Enum SelectedTapInShoppingCart
enum SelectedTapInShoppingCart: Int{
    case normalPurchase = 0
    case regularDelivery = 1
}



