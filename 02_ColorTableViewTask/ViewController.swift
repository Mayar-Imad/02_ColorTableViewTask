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
    
    static func initializeColors() -> [ColorDataSource] {
        let titles = Constants.Text.titles
        let colorNames = Constants.ColorName.colorsName
        let descriptions = Constants.Text.desriptions
        
        var colors: [ColorDataSource] = []
        
        for (index, title) in titles.enumerated() {
            let color = ColorDataSource(
                title: title,
                colorName: colorNames[index],
                description: descriptions[index]
            )
            colors.append(color)
        }
        return colors
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var textViewToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewToEditViewConstraint: NSLayoutConstraint!
    
    private var colors: [ColorDataSource] = ColorDataSource.initializeColors()
    
    private var colorsId: [Int]?
    private var selectedCellsIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorsId = UserDefaults.standard.array(forKey: Constants.colorsIdKey) as? [Int] ?? getColorsIdArray()
        configureViews()
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: Constants.customTableViewCellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CustomTableViewCell.cellId)
        tableView.allowsSelectionDuringEditing = true
    }
    
    private func configureTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.text = Constants.Text.initialDescription
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
    
    private func configureViews() {
        configureTableView()
        configureTextView()
        separatorHight.constant = 1/UIScreen.main.scale
        configureRightButtonItem()
        configureEditView()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        configureEditView()
        selectedCellsIndex.removeAll()
        tableView.reloadData()
    }
    
    private func getColorsIdArray() -> [Int] {
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
            } else if let indexToRemove = selectedCellsIndex.firstIndex(of: indexPath.row) {
                selectedCellsIndex.remove(at: indexToRemove)
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





