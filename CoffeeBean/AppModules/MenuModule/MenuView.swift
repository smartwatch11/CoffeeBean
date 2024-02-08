import UIKit
import SnapKit
import Kingfisher

protocol MenuViewProtocol: AnyObject {
    var presenter: MenuPresenterProtocol {get set}
    
    func update(with locations: [MenuModel])
    func update(with error: String)
}

final class MenuView: UIViewController, MenuViewProtocol{
    
    //MARK: COMPONENT
    private var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    private let messageLabel: UILabel = UILabel()
    
    private lazy var toCartBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Перейти к оплате", for: .normal)
        view.setTitleColor(textColorBtn, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.backgroundColor = backgroundColorBtn
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(onCartTapped), for: .touchUpInside)
        return view
    }()
    
    //MARK: PROPERTY
    var menuItems: [MenuModel] = []
    var cartItems: [Cart] = []
    
    var presenter: MenuPresenterProtocol = MenuPresenter()
    
    //MARK: - OVERRIDE FUNCS
    override func loadView() {
        super.loadView()
        presenter.viewDidLoad()
        style()
        settings()
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
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.isHidden = false
        messageLabel.text = "Loading..."
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
    }
    
    private func settings() {
        view.addSubview(toCartBtn)
        view.addSubview(collectionView)
        view.addSubview(messageLabel)
        view.backgroundColor = .white
        navigationItem.title = "Меню"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMainListView))
    }
    
    private func createAnchors(){
        toCartBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(19)
            make.bottom.equalTo(view.snp.bottom).inset(50)
            make.height.equalTo(48)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(toCartBtn.snp.bottom).inset(60)
            make.top.equalTo(view.snp.top)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self.view)
        }
        
    }
    
    @objc func onCartTapped() {
        self.toCartBtn.zoomInWithEasing()
        self.presenter.goToCartView()
    }
}

extension MenuView {
    func update(with locations: [MenuModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.menuItems = locations
            self?.messageLabel.isHidden = true
            self?.collectionView.reloadData()
            self?.collectionView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.menuItems = []
            self?.messageLabel.isHidden = false
            self?.messageLabel.text = error
            self?.collectionView.isHidden = true
        }
    }
}

//MARK: UITableViewProtocols
extension MenuView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.image.kf.setImage(with: URL(string: menuItems[indexPath.row].imageURL))
        cell.name.text = menuItems[indexPath.row].id == 3 ? "Латте" : menuItems[indexPath.row].name // hardcode for bad API
        cell.price.text = "\(menuItems[indexPath.row].price) руб"
        cell.menuView = self
        cell.menuModel = menuItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:205)
    }
    
}
