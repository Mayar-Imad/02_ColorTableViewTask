//
//  ViewController.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 07/08/2023.
//

import UIKit

enum AppConfig {
    static let colorsIdKey = "colorsId"
    static let customTableViewCellNibName = "CustomTableViewCell"
    static let cellId = "myCell"
}

class ColorDataSource {
    let color: UIColor?
    let name: String
    let id: Int
    private static var lastAssignedId: Int = -1
    
    init(color: UIColor?, name: String) {
        self.color = color
        self.name = name
        self.id = ColorDataSource.lastAssignedId + 1
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    
    private var colors: [ColorDataSource] = [
        ColorDataSource(color: UIColor(named: "Deep Teal"), name: "Deep Teal"),
        ColorDataSource(color: UIColor(named: "Catalina Blue"), name: "Catalina Blue"),
        ColorDataSource(color: UIColor(named: "Dark Indigo"), name: "Dark Indigo"),
        ColorDataSource(color: UIColor(named: "Ripe Plum"), name: "Ripe Plum"),
        ColorDataSource(color: UIColor(named: "Mulberry Wood"), name: "Mulberry Wood"),
        ColorDataSource(color: UIColor(named: "Kenyan Copper"), name: "Kenyan Copper"),
        ColorDataSource(color: UIColor(named: "Chestnut"), name: "Chestnut"),
        ColorDataSource(color: UIColor(named: "Antique Bronze"), name: "Antique Bronze")
    ]
    var colorsId: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    
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
        colorsId = UserDefaults.standard.array(forKey: AppConfig.colorsIdKey) as? [Int] ?? colorsId
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
        let indexArray = UserDefaults.standard.array(forKey: AppConfig.colorsIdKey) as? [Int] ?? colorsId
        let index = indexArray[indexPath.row]
        cell?.configure(colorName: colors[index].name, BGColor: colors[index].color ?? .purple, isLast: isLast)
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
        textView.backgroundColor = colors[indexPath.row].color
        textView.text = "Description\n\n" + colors[indexPath.row].name
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





