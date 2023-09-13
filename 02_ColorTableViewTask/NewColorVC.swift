//
//  NewColorVC.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 05/09/2023.
//

import UIKit

class NewColorVC: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var colorTitleTextField: UITextField!
    @IBOutlet weak var selectColorBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    private var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        configureSelectColorBtn()
        configureDescriptionTextView()
    }
    
    private func configureSelectColorBtn() {
        selectColorBtn.configuration?.cornerStyle = .capsule
        backgroundConfig.backgroundColor = .blue
        selectColorBtn.configuration?.background = backgroundConfig
    }
    
    private func configureDescriptionTextView() {
        // Show Borders
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        
        // Make Borders Rounded
        descriptionTextView.layer.cornerRadius = 20
        descriptionTextView.layer.masksToBounds = true
        
        // insets
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectColorBtnTapped(_ sender: Any) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        backgroundConfig.backgroundColor = color
        selectColorBtn.configuration?.background = backgroundConfig
    }
}
