//
//  ViewController.swift
//  RealmT
//
//  Created by 배지호 on 2018. 5. 20..
//  Copyright © 2018년 baejiho. All rights reserved.
//

import UIKit
import RealmSwift

class Cart: Object {
  @objc dynamic var name: String = ""
}

class ViewController: UIViewController {
  
  @IBOutlet weak var mainTF: UITextField!
  @IBOutlet weak var tableView: UITableView!
  var notificationToken: NotificationToken?
  var realm: Realm?
  var items: Results<Cart>?
  
  @IBAction func btn(_ sender: Any) {
    let cart = Cart()
    cart.name = mainTF.text!
    try! realm?.write {
      realm?.add(cart)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self as UITableViewDataSource
    //migration이 필요할때 데이터베이스 초기화
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    Realm.Configuration.defaultConfiguration = config
    //realm 실행
    realm = try! Realm()
    //Cart라는 데이터가 items에 담기게 됨
    items = realm?.objects(Cart.self)
    //데이터베이스의 데이터가 변경 될 때마다 tableView를 다시 그림
    //push Driven 작동
    notificationToken = realm?.observe({ (noti, realm) in
      self.tableView.reloadData()
    })
  }
  //viewController에까지 push Driven시키면 안되기때문에 뷰가 종료될때 notificationToken?.invalidate() 실행
  override func viewWillDisappear(_ animated: Bool) {
    notificationToken?.invalidate()
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (items?.count)!
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
    cell.textLabel?.text = items![indexPath.row].name
    return cell
  }
}
