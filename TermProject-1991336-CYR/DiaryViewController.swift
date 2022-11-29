//
//  DiaryViewController.swift
//  TermProject-1991336-CYR
//
//  Created by Yerin Choo on 2022/06/12.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI
import FirebaseFirestore

class DiaryViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var diaryText: UITextView!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var titleText: UITextView!
    
    let imagePickerController = UIImagePickerController()
    
    let storage = Storage.storage()
    
    var selectedDateString : String = ""
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        //photoImageView.image = image
        //print(image)
        //print(selectedDateString)
        dateTextLabel.text = selectedDateString
        downloadImageFBS()
        downloadDiaryText()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func setImageButtonTouched(_ sender: UIButton) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension DiaryViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]{
            photoImageView.image = image as! UIImage
        }
        uploadImageFBS(img: photoImageView.image!)
        dismiss(animated: true, completion: nil )
    }
    
}


extension DiaryViewController{
    func uploadImageFBS(img: UIImage){
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        let filePath = selectedDateString
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        Storage.storage().reference().child(filePath).putData(data, metadata: metaData){
            (metaData,error) in
            if let error = error { //실패
                print(error)
                return
            }else{ //성공
                // 새 사진을 불러오기 위해 캐시 데이터 삭제
                SDImageCache.shared.clearMemory()
                SDImageCache.shared.clearDisk()
                
                self.downloadImageFBS()
                print("성공")
            }
        }
    }
    
    func downloadImageFBS(){
        let pathReference = Storage.storage().reference().child(selectedDateString)
        photoImageView.sd_setImage(with: pathReference)
    }
    
    func uploadDiaryText(){
        Firestore.firestore().collection("diary").document(selectedDateString).setData(["title" : titleText.text, "memo" : diaryText.text])
    }
    
    func downloadDiaryText(){
        Firestore.firestore().collection("diary").document(selectedDateString).getDocument{
            (document, error) in
            if let document = document, document.exists {
                let title = document.data()?["title", default: ""] ?? "nil"
                let memo = document.data()?["memo", default: ""] ?? "nil"
                
                self.titleText.text = title as! String
                self.diaryText.text = memo as! String
                
            } else {
                print("Document does not exist")
            }
        }
    }
}

extension DiaryViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toMain"{
            let mainViewController = segue.destination as! MainViewController
            mainViewController.selectedDateString = self.selectedDateString
            uploadDiaryText()
        }
    }
}
