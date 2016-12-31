//
//  ComposeViewController.swift
//  YoungWeibo
//
//  Created by Young on 2016/12/17.
//  Copyright © 2016年 杨羽. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    //xib控件
    @IBOutlet weak var picCollecViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var picCollecV: PicturePickerCollecView!
    //输入框
    @IBOutlet weak var textV: ComposeTextView!
    @IBOutlet weak var toolBarButtomCons: NSLayoutConstraint!
    
    //懒加载
    fileprivate lazy var titView : ComposeTitleView = ComposeTitleView()
    fileprivate lazy var emojiVC : EmojiViewController = EmojiViewController {[weak self] (model) in
        self?.textV.insertEmojition(model: model)
        self?.textViewDidChange((self?.textV)!)
    }
    
    //装图片的数组
    fileprivate lazy var imagesArr : [UIImage] = [UIImage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //1.设置导航栏
        setNavBar()
        
        //监听键盘
        addObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textV.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textV.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //点击图片
    @IBAction func picPickerClick(_ sender: UIButton) {
        
        textV.resignFirstResponder()
        
        picCollecViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    //点击表情
    @IBAction func addEmojiBtnClick(_ sender: Any) {
      
        textV.resignFirstResponder()
        textV.inputView = textV.inputView != nil ? nil : emojiVC.view
        textV.becomeFirstResponder()
    }
 
}


// MARK: -设置ui界面
extension ComposeViewController {

    //设置导航按钮
    fileprivate func setNavBar() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(leftBarbuttonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(rightBarbuttonClick))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        titView.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        navigationItem.titleView = titView
    }
    
    //添加事件监听
    fileprivate func addObserver() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(addPictureVCClick), name: NSNotification.Name.init(addPotoClickNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePictureClick(note:)), name: NSNotification.Name.init(deletePotoClickNotification), object: nil)
    }
}

// MARK: -事件监听
extension ComposeViewController {
    
    //关闭按钮
    @objc fileprivate func leftBarbuttonClick() {
        dismiss(animated: true, completion: nil)
    }
    
    //发送按钮
    @objc fileprivate func rightBarbuttonClick() {

        let finishCallBack : (Bool) -> () = { (success : Bool) in
            if success {
                ShowTip.showHudTip(tipStr: "发送成功")
                self.dismiss(animated: true, completion: nil)
            }else {
                ShowTip.showHudTip(tipStr: "发送失败")
            }
        }
        
        if let image = imagesArr.first {
            //发送带图片的
            NetworkTools.shareInstance.sendWeibo(statusStr: textV.getTextViewAttrString(), image: image, isSuccess: finishCallBack)
        }else {
            NetworkTools.shareInstance.sendWeibo(statusStr: textV.getTextViewAttrString(), isSuccess: finishCallBack)
        }
 
    }
    
    //键盘
    @objc fileprivate func keyboardWillChangeFrame(note : NSNotification) {
        
        let dict = note.userInfo!
        
        let duration =  dict[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        toolBarButtomCons.constant = UIScreen.main.bounds.height - endFrame.origin.y
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
 
    
}




// MARK: -textView代理
extension ComposeViewController :UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        
        textV.placeHolderLab.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textV.resignFirstResponder()
    }
}



// MARK: -处理照片
extension ComposeViewController {

    @objc fileprivate func addPictureVCClick() {
        
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ShowTip.showHudTip(tipStr: "相册不可用")
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc fileprivate func deletePictureClick(note : Notification) {
    
        guard let image = note.object as? UIImage else {
            return
        }
        
        guard let index = imagesArr.index(of: image) else {
            return
        }
        
        imagesArr.remove(at: index)
        
        picCollecV.imagesArr = imagesArr
    }
}



// MARK: -相册的代理
extension ComposeViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        imagesArr.append(image)
        picCollecV.imagesArr = imagesArr
        picker.dismiss(animated: true, completion: nil)
        
    }
}

