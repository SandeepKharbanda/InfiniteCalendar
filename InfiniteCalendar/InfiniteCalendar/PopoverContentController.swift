//
//  PopoverContentController.swift
//  CalenderDemo
//
//  Created by Sandeep Kharbanda on 28/09/19.
//  Copyright © 2019 Sandeep Kharbanda. All rights reserved.
//

import UIKit

protocol PopoverContentControllerDelegate: class {
    func datePickerDoneButtonTapped(_ date: Date, popOverController: UIViewController)
}

class PopoverContentController: UIViewController {

    @IBOutlet weak var datepicker: UIDatePicker!

    weak var delegate: PopoverContentControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepicker.datePickerMode = .date
        datepicker.maximumDate = Date()
        datepicker.date = Date()

    }
    
    @IBAction func datePickerDoneButtonTapped(_ sender: UIButton) {
        delegate?.datePickerDoneButtonTapped(datepicker.date, popOverController: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
