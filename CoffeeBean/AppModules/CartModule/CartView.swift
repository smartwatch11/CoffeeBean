import UIKit
import SnapKit

protocol CartViewProtocol: AnyObject {
    var presenter: CartPresenterProtocol {get set}
    
    func update(with items: [Cart])
    func update(with error: String)
}

final class CartView: UIViewController, CartViewProtocol{
    
    //MARK: COMPONENT
    private let tableView: UITableView = UITableView()
    private let messageLabel: UILabel = UILabel()
    
    //MARK: PROPERTY
    var items: [Cart] = []
    
    var presenter: CartPresenterProtocol = CartPresenter()
    
    private lazy var onPayBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Оплатить", for: .normal)
        view.setTitleColor(textColorBtn, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = backgroundColorBtn
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(onPayTapped), for: .touchUpInside)
        return view
    }()
    
    private let thanksText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Время ожидания заказа\n15 минут!\nСпасибо, что выбрали нас!"
        view.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        view.textColor = backgroundColorBtn
        view.numberOfLines = 3
        view.textAlignment = .center
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
        tableView.register(CartCellView.self, forCellReuseIdentifier: "cartCell")
        tableView.separatorStyle = .none
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isHidden = false
        messageLabel.text = "Loading..."
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
    }
    
    private func settings() {
        view.addSubview(onPayBtn)
        view.addSubview(thanksText)
        view.addSubview(tableView)
        view.addSubview(messageLabel)
        view.backgroundColor = .white
        navigationItem.title = "Ваш заказ"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMainListView))
    }
    
    private func createAnchors(){
        onPayBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(48)
        }
        
        thanksText.snp.makeConstraints { make in
            make.bottom.equalTo(onPayBtn.snp.bottom).inset(70)
            make.height.equalTo(150)
            make.centerX.equalTo(self.view)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(thanksText.snp.bottom).inset(160)
            make.top.equalTo(view.snp.top).inset(100)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self.view)
        }
        
    }
    
    @objc func onPayTapped() {
        self.onPayBtn.zoomInWithEasing()
        self.presenter.goToMainView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
}

extension CartView {
    func update(with items: [Cart]) {
        DispatchQueue.main.async { [weak self] in
            self?.items = items
            self?.messageLabel.isHidden = true
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.items = []
            self?.messageLabel.isHidden = false
            self?.messageLabel.text = error
            self?.tableView.isHidden = true
        }
    }
}

//MARK: UITableViewProtocols
extension CartView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartCellView
        cell.separatorInset = .zero
        cell.contentView.layer.masksToBounds = true
        cell.itemName.text = items[indexPath.section].position.name
        cell.itemDesc.text = "\(items[indexPath.section].position.price) руб"
        cell.count = items[indexPath.section].amount
        cell.countLabel.text = "\(items[indexPath.section].amount)"
        return cell
    }
    
}
