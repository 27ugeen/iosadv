//
//  InfoViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class InfoViewController: UIViewController {
    //MARK: - props
    private var planetInfoModel: PlanetInfoModel?
    private var residentsModel: ResidentsModel?
    private var residentsName: [String] = []
    
    private let viewModel: InfoViewModel
    
    //MARK: - subviews
    private lazy var infoButtton = MagicButton(title: "dont touch me!!!", titleColor: Palette.mainTextColor) {
        self.buttonPressed()
    }
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Orbita"
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - init
    init(viewModel: InfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.decodeModelFromData(costumURL: userURLs.planets.rawValue, modelType: PlanetInfoModel.self) { model in
            self.planetInfoModel = model
            if let urls = self.planetInfoModel?.residents {
                
                for url in urls {
                    self.viewModel.decodeModelFromData(costumURL: url, modelType: ResidentsModel.self) { model in
                        self.residentsModel = model
                        self.residentsName.append(model.name)
                        self.tableView.reloadData()
                    }
                }
            }
            self.orbitalPeriodLabel.text = "Orbital period is: " + (self.planetInfoModel?.orbitalPerion ?? "0") + " solar days"
        }
        
        viewModel.serializeValueFromData(costumURL: userURLs.todos.rawValue, value: "title") { value in
            self.infoLabel.text = value
        }
    }
    //MARK: - methods
    private func buttonPressed() {
        let alertVC = UIAlertController(title: "Error", message: "Something wrong!", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel) { _ in
            print("Destroyed!")
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            print("Survived!")
        }
        alertVC.addAction(actionOk)
        alertVC.addAction(actionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
}
//MARK: - setupTableView
extension InfoViewController {
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Palette.appTintColor
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: String(describing: InfoTableViewCell.self))
        
        tableView.dataSource = self
    }
}
//MARK: - setupViews
extension InfoViewController {
    private func setupViews() {
        self.view.backgroundColor = Palette.infoBackgrdColor

        self.view.addSubview(infoButtton)
        self.view.addSubview(infoLabel)
        self.view.addSubview(orbitalPeriodLabel)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            infoButtton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            infoButtton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoButtton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: infoButtton.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            orbitalPeriodLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            orbitalPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            orbitalPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: orbitalPeriodLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDataSource
extension InfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        residentsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoTableViewCell.self), for: indexPath) as! InfoTableViewCell
        
        cell.label.text = residentsName[indexPath.row]
        return cell
    }
}