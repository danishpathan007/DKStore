//
//  BasketViewController.swift
//  DKStore
//
//  Created by Danish Khan on 21/08/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit

//
//  BasketViewController.swift
//  Market
//
//  Created by David Kababyan on 27/07/2019.
//  Copyright © 2019 David Kababyan. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {

    //MARK: - IBOutlets

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    
    //MARK: - Vars
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIds : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Check if user is logged in
        
        loadBasketFromFirestore()

    }
    
    //MARK: - IBActions

    @IBAction func checkoutButtonPressed(_ sender: Any) {
        
        
    }
    
    //MARK: - Download basket
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore("1234") { (basket) in
            
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            
            downloadItems(basket!.itemIds) { (allItems) in
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
        
    }

    //MARK: - Helper functions
      
      private func updateTotalLabels(_ isEmpty: Bool) {
          
          if isEmpty {
              totalItemsLabel.text = "0"
              basketTotalPriceLabel.text = returnBasketTotalPrice()
          } else {
              totalItemsLabel.text = "\(allItems.count)"
              basketTotalPriceLabel.text = returnBasketTotalPrice()
          }
          
          
          //TODO: Update the button status

      }
      
      private func returnBasketTotalPrice() -> String {
          
          var totalPrice = 0.0
          
          for item in allItems {
              totalPrice += item.price
          }
          
          return "Total price: " + convertToCurrency(totalPrice)
      }



}


extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}




func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) ->Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {
            
            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                
                if snapshot.exists {
                    
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                    
                } else {
                    completion(itemArray)
                }
                
                if count == withIds.count {
                    completion(itemArray)
                }
                
            }
        }
    } else {
        completion(itemArray)
    }
    
    
}

