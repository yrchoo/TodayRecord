//
//  MainViewController.swift
//  TermProject-1991336-CYR
//
//  Created by Yerin Choo on 2022/06/12.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI

class MainViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var fscalendar: FSCalendar!
    var selectedDate : Date? = Date()
    var selectedDateString : String = ""
    let dateFormatter = DateFormatter()
    var image:  UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 날짜 데이터 포맷 형식
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // 현재 날짜를
        selectedDateString = getDateString(date: selectedDate!)
        
        
        // Do any additional setup after loading the view.
        downloadImageFBS()
        print(photoImageView.image)
        image = photoImageView.image
        print(image)
        
        fscalendar.delegate = self
        fscalendar.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadImageFBS()
    }

}

extension MainViewController : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        selectedDateString = getDateString(date: selectedDate!)
        downloadImageFBS()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {

    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        downloadImageFBS()
        return nil
    }
}

extension MainViewController{
    // 날짜 데이터 형식 변경
    func getDateString(date: Date) -> String{
        return dateFormatter.string(from: date)
    }
}

extension MainViewController{
    func downloadImageFBS(){
        let pathReference = Storage.storage().reference().child(selectedDateString)
        photoImageView.sd_setImage(with: pathReference)
    }
}

extension MainViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toDiary"{
            let diaryViewController = segue.destination as! DiaryViewController
            // 현재 선택한 날짜 데이터 전달
            diaryViewController.selectedDateString = self.selectedDateString
        }
    }
}
