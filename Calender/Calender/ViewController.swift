//
//  ViewController.swift
//  Calender
//
//  Created by Immanuel Infant Raj S on 07/06/22.
//

import UIKit
import FSCalendar

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
   // fileprivate weak var calendar: FSCalendar!

    @IBOutlet weak var PreviousButton: UIButton!
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    private var currentPage: Date?
    private lazy var today: Date = {
        return Date()
    }()
    
    var isWeek : Bool = false

    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.calendar.select(Date())
        
        calendar.delegate = self
        calendar.dataSource = self
        
        self.calendar.scope = .month
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        self.calendar.headerHeight = 30.0
        self.calendar.weekdayHeight = 80.0
        self.calendar.currentPage = today
        self.calendar.placeholderType = .fillHeadTail
        self.calendar.firstWeekday = 2
        self.calendar.appearance.titleTodayColor = UIColor.white
        self.calendar.appearance.borderRadius = 0

        self.calendar.appearance.titleSelectionColor = UIColor.red
        self.calendar.appearance.selectionColor = UIColor.clear
        

       // self.calendar.configureAppearance()
       // self.calendar.appearance.todaySelectionColor = UIColor.clear
        self.PreviousButton.isEnabled = false

    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
      //  self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func didActionNext(_ sender: Any) {
        if(self.calendar.scope == .week){
            self.moveCurrentWeek(moveUp: true)
        }else if(self.calendar.scope == .month){
            self.moveCurrentPage(moveUp: true)
        }
        
    }
    @IBAction func didActionPrevious(_ sender: Any) {
        if(self.calendar.scope == .week){
            self.moveCurrentWeek(moveUp: false)
        }else if(self.calendar.scope == .month){
            self.moveCurrentPage(moveUp: false)
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        self.calendar.appearance.titleSelectionColor = UIColor.white
        self.calendar.appearance.todayColor = UIColor.white
        self.calendar.appearance.titleTodayColor = UIColor.blue
        self.calendar.appearance.selectionColor = UIColor.blue
        self.calendar.scope = .week
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
       return Date()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
      //  print("\(self.dateFormatter.string(from: calendar.date(for: calendar)!))")
        print(calendar.selectedDates)
      //  self.calendar.appearance.weekdayTextColor
        
        if self.calendar.scope == .week {
           let startDate = self.calendar.currentPage
           let endDate = self.calendar.gregorian.date(byAdding: .day, value: 7, to: startDate)
            print(startDate)
            print(endDate!)
        }


        
        if(calendar.currentPage == currentPage){
            PreviousButton.isEnabled = false
        }else{
            PreviousButton.isEnabled = true
        }

    }
    
    private func moveCurrentPage(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
    private func moveCurrentWeek(moveUp: Bool) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.weekOfMonth = moveUp ? 1 : -1
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
    
    


}

