
import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    public var count = 0
    
    public var menuView: MenuView?
    public var menuModel: MenuModel?
    
    let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        image.clipsToBounds = true
        return image
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15, weight: .medium)
        name.textColor = secondColorText
        return name
    }()
    
    let price: UILabel = {
        let price = UILabel()
        price.font = .systemFont(ofSize: 14, weight: .bold)
        price.textColor = mainColor
        return price
    }()
    
    let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 14, weight: .regular)
        countLabel.textColor = mainColor
        countLabel.text = "0"
        return countLabel
    }()
    
    lazy var minusBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = textColorBtn
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
        btn.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
        return btn
    }()
    
    lazy var plusBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = textColorBtn
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.addTarget(self, action: #selector(plusCount), for: .touchUpInside)
        return btn
    }()
    
    @objc func minusCount() {
        if self.count - 1 >= 0 {
            self.count -= 1
            self.countLabel.text = "\(self.count)"
            self.countLabel.layoutIfNeeded()
            
            if ((self.menuView?.cartItems.contains(where: {$0.position.id == menuModel?.id})) != nil) {
                self.menuView?.cartItems.removeAll(where: {$0.position.id == menuModel?.id})
                if self.count != 0 {
                    self.menuView?.cartItems.append(Cart(position: menuModel ?? MenuModel(id: 0, name: "Error", imageURL: "", price: 0), amount: self.count))
                }
            } else {
                self.menuView?.cartItems.append(Cart(position: menuModel ?? MenuModel(id: 0, name: "Error", imageURL: "", price: 0), amount: self.count))
            }
        }
    }
    
    @objc func plusCount() {
        if self.count + 1 <= 20 {
            self.count += 1
            self.countLabel.text = "\(self.count)"
            self.countLabel.layoutIfNeeded()
            
            if ((self.menuView?.cartItems.contains(where: {$0.position.id == menuModel?.id})) != nil) {
                self.menuView?.cartItems.removeAll(where: {$0.position.id == menuModel?.id})
                self.menuView?.cartItems.append(Cart(position: menuModel ?? MenuModel(id: 0, name: "Error", imageURL: "", price: 0), amount: self.count))
            } else {
                self.menuView?.cartItems.append(Cart(position: menuModel ?? MenuModel(id: 0, name: "Error", imageURL: "", price: 0), amount: self.count))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settings()
        layerSettings()
    }
    
    private func layerSettings() {
        self.layer.cornerRadius = 10
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    private func settings() {
        addSubview(image)
        image.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(137)
        }
        
        addSubview(name)
        name.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(11)
            make.top.equalTo(image.snp.bottom).offset(10)
            make.height.equalTo(18)
        }
        
        addSubview(price)
        price.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(11)
            make.top.equalTo(name.snp.bottom).offset(10)
            make.height.equalTo(18)
            make.width.equalTo(80)
        }
        
        addSubview(minusBtn)
        minusBtn.snp.makeConstraints { make in
            make.leading.equalTo(price.snp.trailing).offset(3)
            make.top.equalTo(image.snp.bottom).offset(37)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusBtn.snp.trailing).offset(9)
            make.top.equalTo(image.snp.bottom).offset(40)
            make.height.equalTo(17)
        }
        
        addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing).offset(9)
            make.top.equalTo(image.snp.bottom).offset(37)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
