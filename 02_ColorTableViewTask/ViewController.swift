//
//  ViewController.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 07/08/2023.
//

import UIKit

struct ColorDataSource {
    let title: String
    let colorName: String
    let describtion: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    
    private var colors: [ColorDataSource] = [
        ColorDataSource(title: "Deep Teal", colorName: "Deep Teal", describtion: "Deep Teal describtion"),
        ColorDataSource(title: "Catalina Blue", colorName: "Catalina Blue", describtion: "Catalina Blue describtion"),
        ColorDataSource(title: "Dark Indigo", colorName: "Dark Indigo", describtion: "Dark Indigo describtion"),
        ColorDataSource(title: "Ripe Plum", colorName: "Ripe Plum", describtion: "Ripe Plum describtion"),
        ColorDataSource(title: "Mulberry Wood", colorName: "Mulberry Wood", describtion: "Mulberry Wood describtion"),
        ColorDataSource(title: "Kenyan Copper", colorName: "Kenyan Copper", describtion: "Kenyan Copper describtion"),
        ColorDataSource(title: "Chestnut", colorName: "Chestnut", describtion: "Chestnut describtion"),
        ColorDataSource(title: "Antique Bronze", colorName: "Antique Bronze", describtion: "Antique Bronze describtion")
    ]
    private var colorsId: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorsId = UserDefaults.standard.array(forKey: Constants.colorsIdKey) as? [Int] ?? getColorId()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        textView.text = "Description\n\nColors are visual sensations produced by different wavelengths of light. They evoke emotions, convey meaning, and play a vital role in design and communication."
        textView.backgroundColor = UIColor(named: colors[colorsId?[0] ?? 0].colorName)
        textView.isEditable = false
        
        separatorHight.constant = 1/UIScreen.main.scale
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: Constants.customTableViewCellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CustomTableViewCell.cellId)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    private func getColorId() -> [Int] {
        var colorsId: [Int] = []
        for index in 0..<colors.count{
            colorsId.append(index)
        }
        return colorsId
    }
    
    private func getCustomTableViewCellModel(colorArrayIndex index: Int) -> CustomTableViewCellModel {
        let color = colors[index]
        return CustomTableViewCellModel(title: color.title, color: UIColor(named: color.colorName) ?? .black)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellId, for: indexPath) as? CustomTableViewCell
        let index = colorsId?[indexPath.row] ?? 0
        cell?.configure(getCustomTableViewCellModel(colorArrayIndex: index))
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = colorsId?[indexPath.row] ?? 0
        textView.backgroundColor = UIColor(named: colors[index].colorName)
        textView.text = "Description\n\n" + colors[index].describtion
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard var colorsId = colorsId else { return }
        let movedObject = colorsId.remove(at: sourceIndexPath.row)
        colorsId.insert(movedObject, at: destinationIndexPath.row)
        UserDefaults.standard.set(colorsId, forKey: Constants.colorsIdKey)
        self.colorsId = colorsId
        tableView.reloadData()
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





