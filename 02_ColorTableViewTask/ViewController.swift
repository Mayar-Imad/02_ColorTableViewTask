//
//  ViewController.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 07/08/2023.
//

import UIKit

struct AppConfig {
    static let colorsIdKey = "colorsId"
    static let customTableViewCellNibName = "CustomTableViewCell"
    static let cellId = "myCell"
}

struct ColorDataSource {
    let colorName: String
    let describtion: String
    
    init(colorName: String, describtion: String) {
        self.colorName = colorName
        self.describtion = describtion
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    
    private var colors: [ColorDataSource] = [
        ColorDataSource(colorName: "Deep Teal", describtion: "Deep Teal describtion"),
        ColorDataSource(colorName: "Catalina Blue", describtion: "Catalina Blue describtion"),
        ColorDataSource(colorName: "Dark Indigo", describtion: "Dark Indigo describtion"),
        ColorDataSource(colorName: "Ripe Plum", describtion: "Ripe Plum describtion"),
        ColorDataSource(colorName: "Mulberry Wood", describtion: "Mulberry Wood describtion"),
        ColorDataSource(colorName: "Kenyan Copper", describtion: "Kenyan Copper describtion"),
        ColorDataSource(colorName: "Chestnut", describtion: "Chestnut describtion"),
        ColorDataSource(colorName: "Antique Bronze", describtion: "Antique Bronze describtion")
    ]
    var colorsId: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    func configureUI() {
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "Description\n\nColors are visual sensations produced by different wavelengths of light. They evoke emotions, convey meaning, and play a vital role in design and communication."
        textView.backgroundColor = UIColor(named: "Deep Teal")
        textView.isEditable = false
        
        separatorHight.constant = 1/UIScreen.main.scale
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: AppConfig.customTableViewCellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: AppConfig.cellId)
        colorsId = UserDefaults.standard.array(forKey: AppConfig.colorsIdKey) as? [Int] ?? getColorId()
    }
    
    func getColorId ()->[Int] {
        var colorsId: [Int] = []
        for index in 0..<colors.count{
            colorsId.append(index)
        }
        return colorsId
    }
    
    @IBAction func toggleEditingMode(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.setTitle(tableView.isEditing ?  "Done" : "Edit", for: .normal)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConfig.cellId, for: indexPath) as? CustomTableViewCell
        let isLast = indexPath.row == colors.count-1 ? true : false;
        let index = colorsId[indexPath.row]
        cell?.configure(colorName: colors[index].describtion, BGColorName: colors[index].colorName, isLast: isLast)
        // to set the white color for the reorder icon
        cell?.overrideUserInterfaceStyle = .dark
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.backgroundColor = UIColor(named: colors[colorsId[indexPath.row]].colorName)
        textView.text = "Description\n\n" + colors[colorsId[indexPath.row]].describtion
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = colorsId.remove(at: sourceIndexPath.row)
        colorsId.insert(movedObject, at: destinationIndexPath.row)
        UserDefaults.standard.set(colorsId, forKey: AppConfig.colorsIdKey)
    }
    
    // remove the (-) icon
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // remove the space before the icon
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}





