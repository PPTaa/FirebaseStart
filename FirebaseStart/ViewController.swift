//
//  ViewController.swift
//  FirebaseStart
//
//  Created by leejungchul on 2021/03/30.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var numberOfCustomers: UILabel!
    @IBOutlet weak var dataList: UILabel!
    
    @IBAction func createCustomer(_ sender: Any) {
        saveCustomers()
    }
    
    @IBAction func readCustomer(_ sender: Any) {
        fetchCustomers()
    }
    
    @IBAction func updateCustomer(_ sender: Any) {
        updateCustomers()
    }
    
    func updateCustomers() {
        print("run update")
        guard customers.isEmpty == false else { return }
        customers[0].name = "Jack"
        customers[1].books[0].title = "update book"
        customers[1].books[0].author = "update author"
        
        let dictionary = customers.map {$0.toDictionary}
        db.updateChildValues(["customers":dictionary])
    }
    
    @IBAction func deleteCustomer(_ sender: Any) {
        db.child("customers").removeValue()
        Customer.id = 0
    }
    
    
    
    let db = Database.database().reference()
    
    var customers: [Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        writeData()
        updateLabel()
        saveCustomers()
        fetchCustomers()
        
        // update, delete
//        updateData()
//         deleteData()
    }


    func updateLabel() {
        print("update label func start")
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
    
    func writeData(){
        print("write data func start")
        // child("key").setValue()
        // string, number, dictionary, array
        db.child("int").setValue(3)
        db.child("double").setValue(1.1)
        db.child("string").setValue("string write")
        db.child("array").setValue(["a","b","c"])
        db.child("dict").setValue(["key1" : "val1", "key2":"val2", "key3": 10])
        db.child("string").child("deep String").setValue("deep value")
    }
    
    func saveCustomers() {
        // 책가게에서 사용자 저장
        print("save Customer starts")
        // dummy Data
        let books = [Book(title: "book title1", author: "book author1"), Book(title: "book title2", author: "book author2")]
        let customer1 = Customer(id: "\(Customer.id)", name: "Tom", books: books)
        Customer.id += 1
        let customer2 = Customer(id: "\(Customer.id)", name: "Son", books: books)
        Customer.id += 1
        let customer3 = Customer(id: "\(Customer.id)", name: "Kim", books: books)
        Customer.id += 1
        
        db.child("customers").child(customer1.id).setValue(customer1.toDictionary)
        db.child("customers").child(customer2.id).setValue(customer2.toDictionary)
        db.child("customers").child(customer3.id).setValue(customer3.toDictionary)
    }
}

// read(Fetch) Data
extension ViewController {
    func fetchCustomers() {
        db.child("customers").observeSingleEvent(of: .value) { snapshot in
            
             print(snapshot.value)
             print(snapshot.childrenCount)
            // let count = String(snapshot.childrenCount)
            
            do {
                // json형식의 데이터로 변환
                let data = try JSONSerialization.data(withJSONObject: snapshot.value ?? [], options: [])
                // json형식의 데이터를 디코딩해서 코더블 객체로 변환
                let decoder = JSONDecoder()
                // 디코딩 하고 싶은 타입과 디코딩 하고 싶은 데이터를 통해 디코딩
                let customers: [Customer] = try decoder.decode([Customer].self, from: data)
                self.customers = customers
                print("customers count in Do : \(customers.count)")
                print("customers in Do : \(customers)")
                
                DispatchQueue.main.async {
                    self.numberOfCustomers.text = "# Of Customers : \(customers.count)"
                    self.dataList.text = "\(customers)"
                }
                
            } catch let error {
                print("error.localizedDescription : \(error.localizedDescription)")
            }
        }
    }
}
// update, delete
extension ViewController {
    func updateData(){
        db.updateChildValues(["int":999])
        db.updateChildValues(["double":3.14])
        db.updateChildValues(["string":"update value String"])
    }
    
    func deleteData(){
        db.child("int").removeValue()
        db.child("double").removeValue()
        db.child("string").removeValue()
    }
}

struct Customer: Codable {
    let id: String
    var name: String
    var books: [Book]
    
    var toDictionary: [String: Any] {
        let booksArray = books.map { $0.toDictionary }
        let dict: [String:Any] = ["id":id, "name":name, "books":booksArray]
        return dict
    }
    static var id: Int = 0
}

struct Book: Codable {
    var title: String
    var author: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any] = ["title": title, "author":author]
        return dict
    }
}
