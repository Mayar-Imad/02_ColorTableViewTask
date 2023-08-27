//
//  ViewController.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 07/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    
    private var colors: [UIColor?] = [UIColor(named: "Deep Teal"), UIColor(named: "Catalina Blue"), UIColor(named: "Dark Indigo"), UIColor(named: "Ripe Plum"), UIColor(named: "Mulberry Wood"), UIColor(named: "Kenyan Copper"), UIColor(named: "Chestnut"), UIColor(named: "Antique Bronze")]
    private var colorsText: [String] = ["Deep Teal","Catalina Blue", "Dark Indigo", "Ripe Plum", "Mulberry Wood", "Kenyan Copper", "Chestnut", "Antique Bronze"]
    private var colorsId: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
    let userDefaults = UserDefaults.standard
    
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
        let cellNib = UINib(nibName: "CustomTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "myCell")
        colorsId = userDefaults.array(forKey: "colorsId") as? [Int] ?? colorsId
    }
    
    @IBAction func toggleEditingMode(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.setTitle(tableView.isEditing ?  "Done" : "Edit", for: .normal)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomTableViewCell
        let isLast = indexPath.row == colors.count-1 ? true : false;
        let indexArray = userDefaults.array(forKey: "colorsId") as? [Int] ?? colorsId
        let index = indexArray[indexPath.row]
        cell?.configure(colorName: colorsText[index], BGColor: colors[index] ?? .purple, isLast: isLast)
        // to set the white color for the reorder icon
        cell?.overrideUserInterfaceStyle = .dark
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.backgroundColor = colors[indexPath.row]
        textView.text = "Description\n\n" + colorsText[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = colorsId.remove(at: sourceIndexPath.row)
        colorsId.insert(movedObject, at: destinationIndexPath.row)
        userDefaults.set(colorsId, forKey: "colorsId")
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





