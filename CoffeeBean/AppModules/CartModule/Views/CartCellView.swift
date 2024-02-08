import UIKit
import SnapKit


class CartCellView: UITableViewCell {
    
    public var count: Int?
    
    let itemName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        name.numberOfLines = 0
        name.textColor = mainColor
        return name
    }()
    
    let itemDesc: UILabel = {
        let desc = UILabel()
        desc.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        desc.numberOfLines = 0
        desc.textColor = secondColorText
        return desc
    }()
    
    let countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = .systemFont(ofSize: 16, weight: .bold)
        countLabel.textColor = mainColor
        return countLabel
    }()
    
    lazy var minusBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = mainColor
        btn.setImage(UIImage(systemName: "minus"), for: .normal)
        btn.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
        return btn
    }()
    
    lazy var plusBtn: UIButton = {
        let btn = UIButton()
        btn.tintColor = mainColor
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.addTarget(self, action: #selector(plusCount), for: .touchUpInside)
        return btn
    }()
    
    @objc func minusCount() {
        if (self.count ?? 0) - 1 >= 0 {
            self.count! -= 1
            self.countLabel.text = "\(self.count ?? 0)"
            self.countLabel.layoutIfNeeded()
        }
    }
    @objc func plusCount() {
        if (self.count ?? 0) + 1 <= 20 {
            self.count! += 1
            self.countLabel.text = "\(self.count ?? 0)"
            self.countLabel.layoutIfNeeded()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        settings()
    }
    
    private func settings() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor(red: 246/255, green: 229/255, blue: 209/255, alpha: 1)
    }
    
    func setConstraints() {
        self.addSubview(itemName)
        itemName.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(19)
            make.top.equalTo(self.snp.top).offset(19)
            make.height.equalTo(21)
        }
        
        self.addSubview(itemDesc)
        itemDesc.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(19)
            make.top.equalTo(itemName.snp.bottom).offset(19)
            make.height.equalTo(21)
        }
        
        self.contentView.addSubview(minusBtn)
        minusBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(280)
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        
        self.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.leading.equalTo(minusBtn.snp.trailing).offset(9)
            make.top.equalToSuperview().offset(38)
            make.height.equalTo(17)
        }
        
        self.contentView.addSubview(plusBtn)
        plusBtn.snp.makeConstraints { make in
            make.leading.equalTo(countLabel.snp.trailing).offset(9)
            make.top.equalToSuperview().offset(35)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
