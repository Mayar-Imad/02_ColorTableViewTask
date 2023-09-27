//
//  NewColorVC.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 05/09/2023.
//

import UIKit
import CoreData

protocol NewColorDelegate: AnyObject {
    func fetchColorsArray()
    func getColorCount() -> Int
    func showAlert()
}

class NewColorVC: UIViewController {
    
    @IBOutlet weak var colorTitleTextField: CustomTextField!
    @IBOutlet weak var selectColorBtn: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
    private var selectedColor: UIColor = UIColor.purple
    weak var delegate: NewColorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        configureSelectColorBtn()
        configureDescriptionTextView()
    }
    
    private func configureSelectColorBtn() {
        backgroundConfig.backgroundColor = .purple
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
    
    @IBAction func insertNewColor(_ sender: Any) {
        let color = ColorDataSource(context: context)
        color.position = Int32(delegate?.getColorCount() ?? 0)
        color.title = colorTitleTextField.text
        color.color = getColorRGB()
        color.colorDescription = descriptionTextView.text
        
        do {
            try context.save()
        } catch {
            print("Error saving the new color")
        }
        navigationController?.popViewController(animated: true)
        delegate?.showAlert()
        delegate?.fetchColorsArray()
    }
    
    private func getColorRGB() -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        selectedColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        let redInt = Int(r * 255)
        let greenInt = Int(g * 255)
        let blueInt = Int(b * 255)
        let alphaInt = Int(a * 255)
        let colorString = "\(redInt),\(greenInt),\(blueInt),\(alphaInt)"
        return colorString
    }
}

extension NewColorVC: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        backgroundConfig.backgroundColor = selectedColor
        selectColorBtn.configuration?.background = backgroundConfig
    }
}


