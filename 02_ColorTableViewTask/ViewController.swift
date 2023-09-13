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
    let description: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var textViewToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewToEditViewConstraint: NSLayoutConstraint!
    
    private var colors: [ColorDataSource] = [
        ColorDataSource(title: "Deep Teal", colorName: "Deep Teal", description: "Deep Teal description"),
        ColorDataSource(title: "Catalina Blue", colorName: "Catalina Blue", description: "Catalina Blue description"),
        ColorDataSource(title: "Dark Indigo", colorName: "Dark Indigo", description: "Dark Indigo description"),
        ColorDataSource(title: "Ripe Plum", colorName: "Ripe Plum", description: "Ripe Plum description"),
        ColorDataSource(title: "Mulberry Wood", colorName: "Mulberry Wood", description: "Mulberry Wood description"),
        ColorDataSource(title: "Kenyan Copper", colorName: "Kenyan Copper", description: "Kenyan Copper description"),
        ColorDataSource(title: "Chestnut", colorName: "Chestnut", description: "Chestnut description"),
        ColorDataSource(title: "Antique Bronze", colorName: "Antique Bronze", description: "Antique Bronze description")
    ]
    
    private var colorsId: [Int]?
    private var selectedCellsIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        //print(colorsId)
    }
    
    private func configureTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.text = "Description\n\nColors are visual sensations produced by different wavelengths of light. They evoke emotions, convey meaning, and play a vital role in design and communication."
        textView.backgroundColor = UIColor(named: colors[colorsId?[0] ?? 0].colorName)
    }
    
    private func configureRightButtonItem() {
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
    }
    
    private func configureEditView() {
        if isEditing {
            textViewToSuperViewConstraint.isActive = false
            textViewToEditViewConstraint.isActive = true
        } else {
            textViewToEditViewConstraint.isActive = false
            textViewToSuperViewConstraint.isActive = true
        }
        editView.isHidden = !isEditing
    }
    
    private func configureUI() {
        colorsId = UserDefaults.standard.array(forKey: Constants.colorsIdKey) as? [Int] ?? getColorId()
        configureTextView()
        separatorHight.constant = 1/UIScreen.main.scale
        configureRightButtonItem()
        configureEditView()
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: Constants.customTableViewCellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CustomTableViewCell.cellId)
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        configureEditView()
        selectedCellsIndex.removeAll()
        tableView.reloadData()
    }
    
    private func getColorId() -> [Int] {
        var colorsId: [Int] = []
        for index in 0..<colors.count{
            colorsId.append(index)
        }
        return colorsId
    }
    
    private func getCustomTableViewCellModel(forRowAt index: Int) -> CustomTableViewCellModel {
        let colorIndex = colorsId?[index] ?? 0
        let color = colors[colorIndex]
        let cellImageName = isEditing ? selectedCellsIndex.contains(index) ? "checkmark.circle.fill" : "circle"  : "none"
        //print(cellImageName)
        return CustomTableViewCellModel(title: color.title, color: UIColor(named: color.colorName) ?? .black, imageName: cellImageName)
    }
    
    @IBAction func presentNewColorVC(_ sender: Any) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: Constants.NewColorVCIdentifier) as! NewColorVC
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func deleteCells(_ sender: Any) {
        for index in selectedCellsIndex {
            colorsId?.remove(at: index)
        }
        selectedCellsIndex.removeAll()
        UserDefaults.standard.set(colorsId, forKey: Constants.colorsIdKey)
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsId?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellId, for: indexPath) as? CustomTableViewCell
        cell?.configure(getCustomTableViewCellModel(forRowAt: indexPath.row))
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return tableView.isEditing
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isEditing) {
            if (!selectedCellsIndex.contains(indexPath.row)) {
                selectedCellsIndex.append(indexPath.row)
            } else {
                if let indexToRemove = selectedCellsIndex.firstIndex(of: indexPath.row) {
                    selectedCellsIndex.remove(at: indexToRemove)
                }
            }
            tableView.reloadData()
        } else {
            let index = colorsId?[indexPath.row] ?? 0
            textView.backgroundColor = UIColor(named: colors[index].colorName)
            textView.text = "Description\n\n" + colors[index].description
        }
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





