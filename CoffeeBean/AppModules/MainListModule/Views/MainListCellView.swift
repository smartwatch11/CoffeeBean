import UIKit
import SnapKit

class MainListCellView: UITableViewCell {
    
    let itemName: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        name.numberOfLines = 0
        name.textColor = mainColor
        return name
    }()
    
    let itemDesc: UILabel = {
        let desc = UILabel()
        desc.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        desc.numberOfLines = 0
        desc.textColor = secondColorText
        return desc
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
        settings()
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
    }
    
    private func settings() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 10
        
        self.selectionStyle = .none
        self.backgroundColor = textColorBtn
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
