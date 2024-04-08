import UIKit

class CustomButton: UIButton {
    
    init(title: String, titleColor: UIColor){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTapButton(newTapButton: @escaping () -> Void){
        self.tapButtom = newTapButton
    }
    
    private var tapButtom: (() -> Void)?
    
    @objc private func buttonTapped(_ sender: UIButton){
        tapButtom?()
    }
    
    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if (isSelected) {
                alpha = 0.8
            } else {
                alpha = 1
            }
        }
    }
}
