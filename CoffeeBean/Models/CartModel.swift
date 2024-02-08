struct Cart: Codable {
    let position: MenuModel
    var amount: Int
    
    mutating func changeAmount(amount: Int) {
        self.amount = amount
    }
}
