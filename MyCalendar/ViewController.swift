//
//  ViewController.swift
//  MyCalendar
//
//  Created by 张立鑫 on 16/1/6.
//  Copyright © 2016年 zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendarView: CalendarView!
    
    @IBOutlet weak var dateLab: UILabel!
    
    var yearNum = 2016
    var monthNum = 1
    var dayNum = 1
    var numxx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = NSDate().formatDateGMT()
        let com = NSCalendar.currentCalendar().components([.Year,.Month,.Day,.Hour], fromDate: currentDate)
        yearNum = com.year
        monthNum = com.month
        dayNum = com.day
        self.dateLab.text = String("\(yearNum)-\(monthNum)")
        swip()
        self.view.addSubview(calendarView!)
    }
    
    
    func swip(){
        let left = UISwipeGestureRecognizer(target: self, action: "leftSwip:")
        left.direction = UISwipeGestureRecognizerDirection.Left
        left.delegate = self
        left.numberOfTouchesRequired = 1
        
        let rigth = UISwipeGestureRecognizer(target: self, action: "rigthSwip:")
        rigth.direction = UISwipeGestureRecognizerDirection.Right
        rigth.delegate = self
        rigth.numberOfTouchesRequired = 1
        
        self.calendarView!.addGestureRecognizer(left)
        self.calendarView!.addGestureRecognizer(rigth)
    }
    
    func leftSwip(event:UISwipeGestureRecognizer){
        if(monthNum == 12){
            yearNum += 1
            monthNum = 1
        }else{
            monthNum += 1
        }
        createComp()
    }
    
    func createComp(){
        self.dateLab.text = String("\(yearNum)-\(monthNum)")
        let tempCom = NSDateComponents()
        tempCom.year = yearNum
        tempCom.month = monthNum
        tempCom.day = 2
        self.calendarView!.currentLookDate = NSCalendar.currentCalendar().dateFromComponents(tempCom)!.formatDateGMT()
    }

    func rigthSwip(event:UISwipeGestureRecognizer){
        if(monthNum == 1){
            yearNum -= 1
            monthNum = 12
        }else{
            monthNum -= 1
        }
        createComp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self.calendarView, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
}

