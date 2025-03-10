//
//  ViewController.swift
//  CalenderDemo
//
//  Created by Sandeep Kharbanda on 27/09/19.
//  Copyright © 2019 Sandeep Kharbanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    
    let months: [String] = ["January", "February", "March", "April", "May", "June", "July", "August",  "September", "October", "November", "December"]
    
    let defaultDaysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var daysInMonth: [Int] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    var selectedMonth = 0
    
    var calenderData: [[String: Int]] = []

    var year = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        let date = Date()
        let components = Calendar.current.dateComponents([.month, .year], from: date)
        year = components.year!
        selectedMonth = 1 //components.month!
        
        let currentDate = months[selectedMonth - 1] + "," + String(year)
        dateButton.setTitle(currentDate, for: .normal)
        let isLeapYear = year%4 == 0
        if(isLeapYear){
            daysInMonth[1] = 29
        }
        
        for (index, _) in daysInMonth.enumerated(){
            let appendYear = index/12
            let items = daysInMonth[index]
            let previousEmptyBox = getPreviousEmptyBoxes(index%12, year: year + appendYear)
            let weekCount = daysOfWeek.count
            let nextEmptyBoxes = weekCount - (items%weekCount)
            let totalCount = items +  (nextEmptyBoxes == weekCount ? 0 : nextEmptyBoxes)

            let data = ["items":  daysInMonth[index], "previousEmptyBox": previousEmptyBox, "nextEmptyBoxes": nextEmptyBoxes, "totalCount": totalCount]
            calenderData.append(data)
        }

    }
    
    func setCalender(_ date:  Date){
        
        daysInMonth.removeAll()
        daysInMonth.append(contentsOf: defaultDaysInMonth)
        
        let components = Calendar.current.dateComponents([.month, .year], from: date)
        year = components.year!
        selectedMonth = components.month!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        let currentDate = dateFormatter.string(from: date)
        dateButton.setTitle(currentDate, for: .normal)
        let isLeapYear = year%4 == 0
        if(isLeapYear){
            daysInMonth[1] = 29
        }
        
        calenderData.removeAll()
        for (index, _) in daysInMonth.enumerated(){
            let appendYear = index/12
            let items = daysInMonth[index]
            let previousEmptyBox = getPreviousEmptyBoxes(index%12, year: year + appendYear)
            let weekCount = daysOfWeek.count
            let nextEmptyBoxes = weekCount - (items%weekCount)
            let totalCount = items +  (nextEmptyBoxes == weekCount ? 0 : nextEmptyBoxes)

            let data = ["items":  daysInMonth[index], "previousEmptyBox": previousEmptyBox, "nextEmptyBoxes": nextEmptyBoxes, "totalCount": totalCount]
            calenderData.append(data)
            
        }
        
        calenderCollectionView.reloadData()
        perform(#selector(scrollToItem), with: nil, afterDelay: 0.800)
    }

    @objc func scrollToItem() {
        calenderCollectionView.scrollToItem(at: IndexPath(item: 0, section: selectedMonth - 1), at: UICollectionView.ScrollPosition.top, animated: true)
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        
        if let storyboard = self.storyboard{
            let popoverContentController = storyboard.instantiateViewController(identifier: "PopoverContentController") as! PopoverContentController
            popoverContentController.delegate = self
            popoverContentController.view.backgroundColor = .clear

            popoverContentController.modalPresentationStyle = .popover
              popoverContentController.modalPresentationStyle = .overCurrentContext

            let popoverPresentationController = popoverContentController.popoverPresentationController
            popoverPresentationController?.permittedArrowDirections = .up
            popoverPresentationController?.sourceView = self.view
            popoverPresentationController?.sourceRect = sender.frame

            popoverPresentationController?.delegate = self
            present(popoverContentController, animated: true, completion: nil)
                
        }
        
    }

    func setCalenderData(year: Int) {
        
    }
    
    
    func getPreviousEmptyBoxes(_ section: Int, year: Int) -> Int {
        
        let startMonthDate = "1-" + months[section] + "-" + String(year)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-MMMM-yyyy"
        
        let dateFormatted = dateFormatter.date(from: startMonthDate)!
        dateFormatter.dateFormat = "EEE"
        let getMonthDay = dateFormatter.string(from: dateFormatted)
        
        let perviousMonthDayBoxes = daysOfWeek.firstIndex(of: getMonthDay) ?? -1
        return perviousMonthDayBoxes > 0 ? perviousMonthDayBoxes : 0
    }
        
    func appendNextYearCalender(_ section: Int, _ year: Int)  {
        let nextYear = year + 1
        let isLeapYear = nextYear%4 == 0
        
        var appendDays: [Int] = []
        appendDays.append(contentsOf: daysInMonth)
        if(isLeapYear){
            appendDays[1] = 29
        }
        
        for (index, _) in appendDays.enumerated(){
            let items = appendDays[index]
            let previousEmptyBox = getPreviousEmptyBoxes(index%12, year: nextYear)
            let weekCount = daysOfWeek.count
            let nextEmptyBoxes = weekCount - (items%weekCount)
            let totalCount = items +  (nextEmptyBoxes == weekCount ? 0 : nextEmptyBoxes)

            let data = ["items":  appendDays[index], "previousEmptyBox": previousEmptyBox, "nextEmptyBoxes": nextEmptyBoxes, "totalCount": totalCount]
            calenderData.append(data)
            
        }
        
        let sectionCount = section + 11
        
        let indexSet = NSMutableIndexSet.init()
        Array(section...sectionCount).forEach { (indexSection) in
            indexSet.add(indexSection)
        }
        
        var nextYearIndexPaths: [IndexPath] = []
        Array(section...sectionCount).forEach { (nextSection) in
            if(calenderData.count > nextSection){
                let calendarInfo = calenderData[nextSection]
                let days = calendarInfo["totalCount"]! - 1

                let indexPathItems = Array(0...days).map { (nextItem) -> IndexPath in
                    return IndexPath.init(item: nextItem, section: nextSection)
                }
                nextYearIndexPaths.append(contentsOf: indexPathItems)
            }
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        calenderCollectionView.performBatchUpdates({
            calenderCollectionView.insertSections(indexSet as IndexSet)
            calenderCollectionView.insertItems(at: nextYearIndexPaths)

        }) { (finished) in
            CATransaction.commit()
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calenderData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let calenderInfo = calenderData[section]
        return calenderInfo["totalCount"] ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalenderViewCell", for: indexPath) as? CalenderViewCell
        guard let calenderCell: CalenderViewCell = cell else {
            return UICollectionViewCell()
        }
        
        let calenderInfo = calenderData[indexPath.section]
        
        let emptyBoxes = calenderInfo["previousEmptyBox"] ?? 0
        let days = calenderInfo["items"] ?? 0
        let date = indexPath.item + 1 - emptyBoxes

        if(date > 0 && date <= days){
            calenderCell.dateLabel.text =  date == 1 ? String(date) + " "  + months[indexPath.section%12].prefix(3) : String(date)
            calenderCell.tagLabel.text =  "NTH"
        }
        else {
            calenderCell.dateLabel.text =  nil
            calenderCell.tagLabel.text =  nil
        }
        return calenderCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let appendYear = indexPath.section/12
        if(indexPath.section == calenderData.count - 1 && indexPath.item == 0){
            appendNextYearCalender(indexPath.section + 1, year + appendYear)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/7.0, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let visibleCells = calenderCollectionView.visibleCells
        if(visibleCells.count > 0){
            let indexPath = calenderCollectionView.indexPath(for: visibleCells.first!)!
            let appendYear = indexPath.section/12
            let month = months[indexPath.section%12]
            let date = month + "," + String(year + appendYear)
            dateButton.setTitle(date, for: .normal)

        }
    }

}

extension ViewController:  UIPopoverPresentationControllerDelegate, PopoverContentControllerDelegate {
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
            
    }
        
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
            
    }
        
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
         return true
    }
    
    func datePickerDoneButtonTapped(_ date: Date, popOverController: UIViewController) {
        popOverController.dismiss(animated: true) {
            self.setCalender(date)
        }
    }
}

