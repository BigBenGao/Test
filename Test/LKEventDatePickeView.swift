//
//  LKEventDatePickeView.swift
//  Test
//
//  Created by Gao on 2020/6/22.
//  Copyright © 2020 Gao. All rights reserved.
//

import UIKit

@objc
public enum LKDatePickType:Int {
    case unknow
    case yearMonthDayWeekDayAndTime
}

@objc
public enum LKDatePickDatasource:Int {
    case unknow
    case yearMonthDayWeekDay
    case hour
    case minute
}

@objc open class LKEventDatePickeView: UIView {

    var pickerType:LKDatePickType = .yearMonthDayWeekDayAndTime
    
    var pickerView:UIPickerView?

    var dataSource:[LKDatePickDatasource]?
    
    @objc var didSelectDate:((Date?) -> Void)?
    
    var beginDate:Date = Date().addingTimeInterval(-86400 * 366 * 2)
    
    var dateFormatter = DateFormatter()
    
    var parseDateFormatter = DateFormatter()
    
    var numberOfDays = 0
    
    var contentView:UIView?
    
    @objc
    var selectDate:Date? {
        didSet {
            switch pickerType {
            case .yearMonthDayWeekDayAndTime:
                if let date = selectDate {
                    let comp = NSCalendar.current.dateComponents([.hour,.minute], from: date)
                    if let hour = comp.hour, let minute = comp.minute, let dataSource = self.dataSource {
                        for index in 0..<dataSource.count {
                            let dataSourceType = dataSource[index]
                            switch dataSourceType {
                            case .yearMonthDayWeekDay:
                                if let day = Calendar.current.dateComponents([.day], from: beginDate, to: date).day, day >= 0 {
                                    self.pickerView?.selectRow(day, inComponent: 0, animated: true)
                                }
                            case .hour:
                                self.pickerView?.selectRow(hour, inComponent: index, animated: true)
                            case .minute:
                                self.pickerView?.selectRow(minute, inComponent: index, animated: true)
                            default:
                                continue
                            }
                        }
                    }
                }
            default:
                return
            }
        }
    }
    
    @objc
    init(type:LKDatePickType) {
        super.init(frame: UIScreen.main.bounds)
        self.pickerType = type
        switch type {
        case .yearMonthDayWeekDayAndTime:
            dataSource = [.yearMonthDayWeekDay,.hour,.minute]
            dateFormatter.dateFormat = "yyyy-MM-dd EEE"
            dateFormatter.locale = Locale(identifier: "zh-CN")
            parseDateFormatter.dateFormat = "yyyy-MM-dd EEE HH:mm"
            parseDateFormatter.locale = Locale(identifier: "zh-CN")
        default:
            dataSource = nil
        }
        self.setUp()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp() {
        
        let contentView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height))
        contentView.backgroundColor = .lightGray
        self.addSubview(contentView)
        self.contentView = contentView
        
        let toolBarHeight:CGFloat = 44
        let pickerViewHeight:CGFloat = 300
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: self.frame.size.height - pickerViewHeight, width: self.frame.size.width, height: pickerViewHeight))
        pickerView.backgroundColor = .lightGray
        self.pickerView = pickerView
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        contentView.addSubview(pickerView)
        
        let titleView = UIView(frame: CGRect(x: 0, y: pickerView.frame.origin.y - toolBarHeight, width: pickerView.frame.size.width, height: toolBarHeight))
        titleView.backgroundColor = .white
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.titleLabel?.textAlignment = .left
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let cancelButtonSize = cancelButton.sizeThatFits(CGSize(width: 100, height: 44))
        cancelButton.frame = CGRect(x: 0, y: 0, width: Int(cancelButtonSize.width) + 20, height: Int(toolBarHeight))
        titleView.addSubview(cancelButton)
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.titleLabel?.textAlignment = .right
        confirmBtn.setTitle("确认", for: .normal)
        confirmBtn.setTitleColor(.blue, for: .normal)
        let confirmBtnSize = confirmBtn.sizeThatFits(CGSize(width: 100, height: 44))
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        confirmBtn.frame = CGRect(x: self.frame.size.width - confirmBtnSize.width - 20.0, y: 0, width: cancelButtonSize.width + 20.0, height: toolBarHeight)
        titleView.addSubview(confirmBtn)
        
        contentView.addSubview(titleView)
    }
    
    @objc
    public func dismiss() {
        if let contentView = self.contentView {
            UIView.animate(withDuration: 0.4, animations: {
                contentView.center = CGPoint(x: self.frame.size.width / 2.0, y: contentView.center.y + contentView.frame.size.height)
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
    
    @objc
    public func show() {
        if let keyWindow = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first, let contentView = self.contentView {
            keyWindow.addSubview(self)
            UIView.animate(withDuration: 0.4) {
                contentView.center = CGPoint(x: self.frame.size.width / 2.0, y: contentView.center.y - contentView.frame.size.height)
            }
        }
    }
    
    @objc
    public func confirm() {
        switch pickerType {
        case .yearMonthDayWeekDayAndTime:
            if let dataSource = self.dataSource, let pickerView = self.pickerView {
                var compmentString = ""
                for index in 0..<dataSource.count {
                    let selectRow = pickerView.selectedRow(inComponent: index)
                    if let content = self.pickerView(pickerView, titleForRow: selectRow, forComponent: index) {
                        if compmentString.isEmpty {
                            compmentString = content
                        } else {
                            compmentString = compmentString + " " + content
                        }
                    }
                 }
                let date = parseDateFormatter.date(from: compmentString)
                didSelectDate?(date)
            }
        default:
            return
        }
        self.dismiss()
    }
    
    @objc public func reloadAll() {
        self.pickerView?.reloadAllComponents()
    }
    
    func numberOfRows(type:LKDatePickDatasource) -> Int {
        switch type {
        case .yearMonthDayWeekDay:
            if numberOfDays == 0 {
                let maxDate = beginDate.addingTimeInterval(86400 * 366 * 4)
                let comp = NSCalendar.current.dateComponents([.day], from: beginDate, to: maxDate)
                numberOfDays = comp.day ?? 0
            }
            return numberOfDays
        case .hour:
            return 24
        case .minute:
            return 60
        default:
            return 0
        }
    }
    
}

extension LKEventDatePickeView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource?.count ?? 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let dataSource = self.dataSource, dataSource.count > component {
            let dataSourceType = dataSource[component]
            return self.numberOfRows(type: dataSourceType)
        }
        return 0
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let dataSource = self.dataSource, dataSource.count > component {
            let dataSourceType = dataSource[component]
            switch dataSourceType {
            case .yearMonthDayWeekDay:
                let content = dateFormatter.string(from: self.beginDate.addingTimeInterval(TimeInterval(row * 86400)))
                return content
            case .hour,.minute:
                return String(format: "%02d", row)
            default:
                return ""
            }
        }
        return ""
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = title
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
    
}
