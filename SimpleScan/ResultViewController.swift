//
//  ResultViewController.swift
//  SimpleScan
//
//  Created by Amelia While on 27/12/2024.
//

import UIKit
import VisionKit

internal class ResultViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Result")
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var copyButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Copy"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(copyValue), for: .touchUpInside)
        return button
    }()
    
    internal init(item: RecognizedItem.Barcode) {
        super.init(nibName: nil, bundle: nil)
        
        self.valueLabel.text = item.payloadStringValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        view.addSubview(valueLabel)
        view.addSubview(copyButton)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 44),
            
            valueLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            valueLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25),
            valueLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: 44),
            
            copyButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            copyButton.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 25),
            copyButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func copyValue() {
        UIPasteboard.general.string = valueLabel.text
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
}
