//
//  CalendarView.swift
//  MyCalendar
//
//  Created by 张立鑫 on 16/1/6.
//  Copyright © 2016年 zhang. All rights reserved.
//

import UIKit

extension NSDate{
    // 把utc 时间 转换成 gmt 时间  相差8小时
    func formatDateGMT() ->NSDate{
        let comp = NSCalendar.currentCalendar().components([.Year,.Month,.Day,.Hour,.Minute,.Second], fromDate: self)
        comp.hour += 8
        return NSCalendar.currentCalendar().dateFromComponents(comp)!
    }
}

extension UIView {
    func animateWhenClicked() {
//        self.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        self.layer.transform = CATransform3DMakeScale(1.5, 1.5, 0)
        UIView.animateWithDuration(0.5, animations: {
//            self.backgroundColor = UIColor.blackColor()
            self.layer.transform = CATransform3DMakeTranslation(1, 1, 1)
        })
    }
}


class CalendarView: UIView {

    let weekArr = ["日","一","二","三","四","五","六"]
    var contentView = UIView()
    var daysArr = [Int]()
    var btnsArr = [UIButton]()
    var everyWidth:CGFloat = 0
    var everyHeight:CGFloat = 0
    // 当前查看的日期
    var currentLookDate:NSDate = NSDate().formatDateGMT(){
        didSet(newDate){
            self.drawMyView()
        }
    }
    
    // 本月共多少天
    var monthDayNum = 0
    // 一共有多少行
    var calendarRowNum = 0
    // 本月一号是星期几
    var oneDayWeekNum = 1
    // 本月最后一天是星期几
    var endDayWeekNum = 28
    // 上月天数
    var lastMonthDayNum = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // 开始需要添加的天数
        let addDaysNum = oneDayWeekNum - 1
        // 结束需要添加的天数
        let addDaysNumEnd = 7 - endDayWeekNum
        // 下个月的第一天
        var nextMonthNum = 1
        // 得到一共需要多少行数据
        calendarRowNum = (addDaysNum + addDaysNumEnd + monthDayNum) / 7
        
        let start = lastMonthDayNum - oneDayWeekNum + 2
        var oneDay = 1
        
        let frame = self.frame
        let width = frame.size.width
        
        everyWidth = width / 7
        
        if(UIDevice.currentDevice().orientation.isLandscape){
            everyHeight = everyWidth / 3
        }else{
            everyHeight = everyWidth
        }

        
        let currentDay = NSDate().formatDateGMT()
        let com = NSCalendar.currentCalendar().components([.Year,.Month,.Day,], fromDate: currentDay)
        let dayNum = com.day
        let yearNum = com.year
        let monthNum = com.month
        
        let currentCom = NSCalendar.currentCalendar().components([.Year,.Month], fromDate: currentLookDate)
        
        for(var i = 1; i <= calendarRowNum; i++){
            for(var j = 0; j < 7; j++){
                let tb = UIButton(frame:CGRectMake(CGFloat(j)*everyWidth,CGFloat(i - 1) * everyHeight,everyWidth, everyHeight ))
                if(i == 1){
                    if(start + j <= lastMonthDayNum){
                        let tv = start + j
                        daysArr.append(tv)
                        tb.backgroundColor = UIColor.lightGrayColor()
                        tb.alpha = 0.4
                    }else{
                        daysArr.append(oneDay++)
                        tb.backgroundColor = UIColor.whiteColor()
                    }
                }else{
                    if(oneDay <= monthDayNum){
                        daysArr.append(oneDay++)
                        tb.backgroundColor = UIColor.whiteColor()
                    }else{
                        daysArr.append(nextMonthNum++)
                        tb.backgroundColor = UIColor.lightGrayColor()
                        tb.alpha = 0.4
                    }
                }
                tb.layer.cornerRadius = everyHeight / 2
                tb.clipsToBounds = true
                
                if(dayNum == daysArr[daysArr.count - 1] && currentCom.year == yearNum &&  currentCom.month == monthNum){
                    tb.backgroundColor = UIColor.redColor()
                }
                tb.addTarget(self, action: "dateClick:", forControlEvents: .TouchUpInside)
                tb.setTitleColor(UIColor.blackColor(), forState: .Normal)
                tb.setTitle(String(daysArr[daysArr.count - 1]), forState: .Normal)
                                
//                tb.layer.masksToBounds = true
//                tb.layer.shadowColor = UIColor.greenColor().CGColor
//                tb.layer.borderColor = UIColor.blueColor().CGColor
//                tb.layer.shadowOffset = CGSizeMake(4.0, 4.0)
//                tb.layer.shadowOpacity = 0.5
//                tb.layer.shadowRadius = 2
//                tb.layer.borderWidth = 1
                
                btnsArr.append(tb)
                self.addSubview(tb)
                
                UIView.animateWithDuration(0, animations: { () -> Void in
                    let identity = CATransform3DIdentity
                    let angle = 90 * M_PI / 180
                    let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
                    tb.layer.transform = rotateTransform
                }, completion: { (res) -> Void in
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        let identity = CATransform3DIdentity
                        let angle = 0 * M_PI / 180
                        let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
                        tb.layer.transform = rotateTransform
                    })
                })
            }
        }
    }
    
    func dateClick(btn:UIButton){
        btn.animateWhenClicked()
        print("点击了 \(btn.currentTitle!) 日 ")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        drawMyView()
        // 注册屏幕旋转通知
        NSNotificationCenter.defaultCenter().addObserverForName(UIDeviceOrientationDidChangeNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: rotatingView)
    }
    
    // 屏幕旋转重新绘制视图
    func rotatingView(par:NSNotification){
        drawMyView()
    }
    
    func drawMyView(){
        daysArr.removeAll()
        
        let _ = btnsArr.map { (btn) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                let identity = CATransform3DIdentity
                let angle = 90 * M_PI / 180
                btn.alpha = 0.4
                let rotateTransform = CATransform3DRotate(identity, CGFloat(angle), 0.0, 1.0, 0.0)
                btn.layer.transform = rotateTransform
            }, completion: { (res) -> Void in
                btn.removeFromSuperview()
            })
        }
        
        btnsArr.removeAll()
        self.backgroundColor = UIColor.clearColor()
        monthDayNum = getMonthDayNum(1)
        endDayWeekNum = getWeekDayNum(monthDayNum)
        oneDayWeekNum = getWeekDayNum(1)
        lastMonthDayNum = getMonthDayNum(-1)
        self.setNeedsDisplay()
    }

    // 获取本月某号是星期几
    func getWeekDayNum(num:Int) ->Int{
        let oneDay = getMonthOneDay(num)
        let calendar = NSCalendar.currentCalendar()
        let weekNum = calendar.components([NSCalendarUnit.Weekday], fromDate: oneDay)
        return weekNum.weekday
    }
    
    // 获取本月某号
    func getMonthOneDay(num:Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: currentLookDate)
        comp.day = num
        // 本月一号
        let oneDay = calendar.dateFromComponents(comp)
        return oneDay!
    }
    
    // 获取当月有多少天,或者上月多少天 , 1 为当月, -1为上月
    func getMonthDayNum(num:Int) ->Int{
        let calendar = NSCalendar.currentCalendar()
        let oneDay = getMonthOneDay(2)
        let nextMonth = NSDateComponents()
        nextMonth.month = num
        
        let nextMonthOneDay = calendar.dateByAddingComponents(nextMonth, toDate: oneDay, options: NSCalendarOptions.init(rawValue: 0))
        
        let daysCom = calendar.components([NSCalendarUnit.Day], fromDate: oneDay, toDate: nextMonthOneDay! , options: NSCalendarOptions.init(rawValue: 0) )
        return abs(daysCom.day)
    }
        
}
