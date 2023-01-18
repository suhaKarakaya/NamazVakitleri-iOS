//
//  TimeTableViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

protocol TimeTableViewInterface: AnyObject {
    func prepareTableView()
    func prepareGetData(tempDicsList: [Vakit])
    func startLoading()
    func stopLoading()
    func setLabelLocation(title: String)
}

final class TimeTableViewController: UIViewController {
    
    @IBOutlet weak private var labelLocation: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    private lazy var viewModel = TimeTableViewModel()
    private var tempDicsList: [Vakit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

extension TimeTableViewController: TimeTableViewInterface,UITableViewDelegate,UITableViewDataSource  {
    func setLabelLocation(title: String) { self.labelLocation.text = title }
    
    func startLoading() { LoadingIndicatorView.show(self.view) }
    
    func stopLoading() { LoadingIndicatorView.hide() }

    func prepareGetData(tempDicsList: [Vakit]) {
        self.tempDicsList = tempDicsList
        tableView.reloadData()
    }
    
    func prepareTableView() {
        tableView.register(UINib(nibName: "DailyPrayTimeViewCell", bundle: nil), forCellReuseIdentifier: "DailyPrayTimeViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyPrayTimeViewCell", for: indexPath) as? DailyPrayTimeViewCell else { return UITableViewCell() }
        cell.data = viewModel.cellForRowAt(indexPath: indexPath)
        return cell
    }
}
