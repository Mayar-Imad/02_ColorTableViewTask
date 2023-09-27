//
//  ViewController.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 07/08/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, NewColorDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorHight: NSLayoutConstraint!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var textViewToSuperViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewToEditViewConstraint: NSLayoutConstraint!
    
    private var colors = [ColorDataSource]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var selectedCellsIndex: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //deleteAll()
        fetchColorsArray()
        configureViews()
    }
    
    private func deleteAll() {
        let fetchRequest: NSFetchRequest<ColorDataSource> = ColorDataSource.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            colors = []
            tableView.reloadData()
        } catch {
            print("Error deleting objects: \(error)")
        }
    }
    
    func fetchColorsArray() {
        do {
            let fetchRequest: NSFetchRequest<ColorDataSource> = ColorDataSource.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            self.colors = try context.fetch(fetchRequest)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching the colors array")
        }
    }
    
    func getColorCount() -> Int {
        return colors.count
    }
    
    private func configureTableView() {
        let cellNib = UINib(nibName: Constants.Name.customTableViewCellNibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CustomTableViewCell.cellId)
        tableView.allowsSelectionDuringEditing = true
    }
    
    private func configureTextView() {
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.text = Constants.Text.initialDescription
        textView.backgroundColor = (!colors.isEmpty) ? getUIColor(rgbString: colors[0].color) : UIColor.purple
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
    
    private func getCustomTableViewCellModel(forRowAt index: Int) -> CustomTableViewCellModel {
        let color = colors[index]
        let cellImageName = isEditing ? selectedCellsIndex.contains(index) ? "checkmark.circle.fill" : "circle"  : "none"
        let bgColor = getUIColor(rgbString: color.color)
        return CustomTableViewCellModel(title: color.title ?? "purple", color: bgColor, imageName: cellImageName)
    }
    
    private func getUIColor(rgbString: String?) -> UIColor {
        let colorStr = rgbString ?? "0,0,0"
        let components = colorStr.split(separator: ",")
        let red = Int(components[0]) ?? 0
        let green = Int(components[1]) ?? 0
        let blue = Int(components[2]) ?? 0
        let redFloat = CGFloat(red) / 255.0
        let greenFloat = CGFloat(green) / 255.0
        let blueFloat = CGFloat(blue) / 255.0
        return UIColor(red: redFloat, green: greenFloat, blue: blueFloat, alpha: 1.0)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Success", message: "Color added successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func presentNewColorVC(_ sender: Any) {
        let destVC = storyboard?.instantiateViewController(withIdentifier: Constants.NewColorVCIdentifier) as! NewColorVC
        destVC.delegate = self
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func deleteCells(_ sender: Any) {
        for index in selectedCellsIndex {
            self.context.delete(colors[index])
        }
        
        for (i, color) in colors.enumerated() {
            color.position = Int32(i)
        }
        
        do {
            try self.context.save()
        } catch {
            print("Error contest.save")
        }
        
        fetchColorsArray()
        selectedCellsIndex.removeAll()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
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
            //print(colors[indexPath.row].colorName)
            textView.backgroundColor = getUIColor(rgbString: colors[indexPath.row].color)
            textView.text = "Description\n\n" + (colors[indexPath.row].colorDescription ?? "Purple description")
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = colors.remove(at: sourceIndexPath.row)
        colors.insert(movedObject, at: destinationIndexPath.row)
        
        for (i, color) in colors.enumerated() {
            color.position = Int32(i)
        }
        
        do {
            try self.context.save()
            print("changes are saved")
        } catch {
            print("Error contest.save")
        }
        
        //fetchColorsArray()
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





