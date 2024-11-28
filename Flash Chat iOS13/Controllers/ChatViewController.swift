//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        //        Message(sender: "1@2.com", body: "你好"),
        //        Message(sender: "a@b.com", body: "亲，你好。有什么可以帮你的？妹妹得分呵呵呵呵呵呵份额粉色额服务费得到对我的我的娃的王凤伟"),
        //        Message(sender: "1@2.com", body: "我想买个电脑。")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        //去掉back按钮
        navigationItem.hidesBackButton = true
        //上面正中间的标题
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        Task {
            await loadMessages()
        }
        
    }
    
    func loadMessages() async{
        
        //实时更新信息 - addSnapshotListener
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let error{
                print("There was an isssue retrieving data from Firestore, \(error)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents{
                    for document in snapshotDocuments {
                        //                print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            //后台运行异步任务
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
    }

// 仅读取信息
//        do {
//            let snapshot = try await db.collection(K.FStore.collectionName).getDocuments()
//            for document in snapshot.documents {
////                print("\(document.documentID) => \(document.data())")
//                let data = document.data()
//                if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
//                    let newMessage = Message(sender: messageSender, body: messageBody)
//                    messages.append(newMessage)
//                    
//                    //后台运行异步任务
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                    
//                }
//            }
//        } catch {
//            print("Error getting documents: \(error)")
//        }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //Auth提供的访问用户名的方法
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970 //时间戳
            ]) {error in
                if let error {
                    print("There is an issue saving data to firestore, \(error)")
                } else {
                    print("Successfully saved data.")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true) //回到主画面
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource{
    //有多少行
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //用哪个cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for:indexPath) as! MessageCell //as!强制类型下降
        cell.label.text = messages[indexPath.row].body
        return cell
        
    }
    
    
}
