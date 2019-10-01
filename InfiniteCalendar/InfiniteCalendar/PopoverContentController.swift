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

    @IBOutlet weak var datepickerView: UIView!

    weak var delegate: PopoverContentControllerDelegate?
    
    private var month: Int!
    private var year: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepickerView.layer.cornerRadius = 10
        
        let shadowPath = UIBezierPath(rect: datepickerView.bounds)
        datepickerView.layer.masksToBounds = false
        datepickerView.layer.shadowColor = UIColor.black.cgColor
        datepickerView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        datepickerView.layer.shadowOpacity = 0.5
        datepickerView.layer.shadowPath = shadowPath.cgPath

        
        let expiryDatePicker = MonthYearPickerView()
        
        let date = Date()
        let components = Calendar.current.dateComponents([.month, .year], from: date)
        
        self.month = components.month!
        self.year = components.year!
        expiryDatePicker.month = self.month
        expiryDatePicker.year = self.year
        
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            self.month = month
            self.year = year
        }
        datepickerView.addSubview(expiryDatePicker)
        
        

    }
    
    @IBAction func datePickerDoneButtonTapped(_ sender: UIButton) {
        let pickerDate = String(self.month) + "-" + String(self.year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        delegate?.datePickerDoneButtonTapped(dateFormatter.date(from: pickerDate) ?? Date(), popOverController: self)
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
