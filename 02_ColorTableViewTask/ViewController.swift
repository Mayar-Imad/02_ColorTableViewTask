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
    private var colors: [UIColor?] = [UIColor(named: "Deep Teal"), UIColor(named: "Catalina Blue"), UIColor(named: "Dark Indigo"), UIColor(named: "Ripe Plum"), UIColor(named: "Mulberry Wood"), UIColor(named: "Kenyan Copper"), UIColor(named: "Chestnut"), UIColor(named: "Antique Bronze")]
    private var colorsText: [String] = ["Deep Teal","Catalina Blue", "Dark Indigo", "Ripe Plum", "Mulberry Wood", "Kenyan Copper", "Chestnut", "Antique Bronze"]
    
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
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? CustomTableViewCell
        //        cell?.colorLabel.text = colorsText[indexPath.row]
        //        cell?.backgroundColor = colors[indexPath.row]
        cell?.configure(colorName: colorsText[indexPath.row], BGColor: colors[indexPath.row] ?? .purple)
        return cell ?? UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.backgroundColor = colors[indexPath.row]
        textView.text = "Description\n\n" + colorsText[indexPath.row]
    }
}

