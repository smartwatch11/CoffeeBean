import UIKit
import SnapKit

protocol MainListViewProtocol: AnyObject {
    var presenter: MainListPresenterProtocol {get set}
    
    func update(with locations: [LocationModel])
    func update(with error: String)
}

final class MainListView: UIViewController, MainListViewProtocol{
    
    //MARK: COMPONENT
    private let tableView: UITableView = UITableView()
    private let messageLabel: UILabel = UILabel()
    
    //MARK: PROPERTY
    var locations: [LocationModel] = []
    
    var presenter: MainListPresenterProtocol = MainListPresenter()
    
    private lazy var onMapBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("На карте", for: .normal)
        view.setTitleColor(textColorBtn, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = backgroundColorBtn
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(onMapTapped), for: .touchUpInside)
        return view
    }()

    //MARK: - OVERRIDE FUNCS
    
    override func loadView() {
        super.loadView()
        presenter.viewDidLoad()
        settings()
        style()
    }
    
    @objc private func backToMainListView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func logout() {
        self.presenter.quitFromApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createAnchors()
    }
    
    //MARK: - SETTING FUNCS
    
    private func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainListCellView.self, forCellReuseIdentifier: "listCell")
        tableView.separatorStyle = .none
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isHidden = false
        messageLabel.text = "Loading..."
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
    }
    
    private func settings() {
        view.addSubview(onMapBtn)
        view.addSubview(tableView)
        view.addSubview(messageLabel)
        view.backgroundColor = .white
        navigationItem.title = "Ближайшие кофейни"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .plain, target: self, action: #selector(logout))
    }
    
    private func createAnchors(){
        onMapBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(48)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(onMapBtn.snp.bottom).inset(60)
            make.top.equalTo(view.snp.top).inset(100)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self.view)
        }
    }
    
    @objc func onMapTapped() {
        self.onMapBtn.zoomInWithEasing()
        self.presenter.goToMapView(locations: locations)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
}

extension MainListView {
    func update(with locations: [LocationModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.locations = locations
            self?.messageLabel.isHidden = true
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.locations = []
            self?.messageLabel.isHidden = false
            self?.messageLabel.text = error
            self?.tableView.isHidden = true
        }
    }
}

//MARK: UITableViewProtocols
extension MainListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! MainListCellView
        cell.separatorInset = .zero
        cell.contentView.layer.masksToBounds = true
        cell.itemName.text = locations[indexPath.section].name
        cell.itemDesc.text = "\(Int(Double(locations[indexPath.section].point.latitude) ?? 0)) км от вас"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.goToMenuView(id: locations[indexPath.section].id)
    }
}
