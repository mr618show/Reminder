//
//  TodoSchedulingViewController.swift
//  LocalNotification
//
//  Created by Rui Mao on 5/31/17.
//  Copyright © 2017 Rui Mao. All rights reserved.
//

import UIKit

class TodoSchedulingViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        let todoItem = TodoItem(deadline: deadlinePicker.date, title: titleField.text!, UUID: UUID().uuidString)
        TodoList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
        let _ = self.navigationController?.popToRootViewController(animated: true) // return to list view
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
