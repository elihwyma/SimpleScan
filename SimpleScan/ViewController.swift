//
//  ViewController.swift
//  BarcodeScannerExample
//
//  Created by Amelia While on 27/12/2024.
//

import UIKit
import VisionKit
import AVFoundation

class ViewController: UIViewController, DataScannerViewControllerDelegate {
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = String(localized: "Simple Scan")
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let accuracySelector: UISegmentedControl = {
        let accuracySelector = UISegmentedControl(items: [
            "Fast",
            "Balanced",
            "Accurate"
        ])
        accuracySelector.translatesAutoresizingMaskIntoConstraints = false
        accuracySelector.selectedSegmentIndex = 2
        return accuracySelector
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Start Scanning"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(startScanning), for: .touchUpInside)
        return button
    }()
    
    private let enableTorch: UISwitch = {
        let switcher = UISwitch(frame: .zero)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private let enableTorchLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Enable Torch")
        label.textAlignment = .left
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.monitorTorch()
        
        let stackView = UIStackView(arrangedSubviews: [enableTorchLabel, enableTorch])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(accuracySelector)
        view.addSubview(stackView)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            
            accuracySelector.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            accuracySelector.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            accuracySelector.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            
            stackView.topAnchor.constraint(equalTo: accuracySelector.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            
            startButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
        ])
    }
    
    @objc private func startScanning() {
        let viewController = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [ .code39, .code128, .code93, .code93i, .code39Checksum, .code39FullASCII, .code39FullASCIIChecksum ])],
            qualityLevel: .init(rawValue: accuracySelector.selectedSegmentIndex),
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isHighlightingEnabled: false)
        
        viewController.delegate = self
        
        self.present(viewController, animated: true, completion: nil)
        do {
            try viewController.startScanning()
        } catch {
            
        }
    }

    private func monitorTorch() {
        let noti: NSNotification.Name
        if #available(iOS 18, *) {
            noti = AVCaptureSession.didStartRunningNotification
        } else {
            noti = .AVCaptureSessionDidStartRunning
        }
        NotificationCenter.default.addObserver(forName: noti, object: nil, queue: nil) { [self] notification in
            Task { @MainActor in
                guard self.enableTorch.isOn else {
                    return
                }
                forceTorch()
            }
        }
    }
    
    private func forceTorch() {
        var device: AVCaptureDevice?
        
        if #available(iOS 17, *) {
            device = AVCaptureDevice.userPreferredCamera
        } else {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera, .builtInDualWideCamera, .builtInUltraWideCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: AVMediaType.video, position: .back)
            device = deviceDiscoverySession.devices.first
        }
        guard let device else { return }
        
        if device.hasTorch && device.isTorchAvailable {
            do {
                try device.lockForConfiguration()
                try device.setTorchModeOn(level: 1.0)
                device.unlockForConfiguration()
                print("Set Torch Mode to 1.0")
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard case let .barcode(item) = addedItems.first else {
            return
        }
        dataScanner.stopScanning()
        print("Got \(item)")
        dataScanner.dismiss(animated: true) {
            let vc = ResultViewController(item: item)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

fileprivate extension DataScannerViewController.QualityLevel {
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .fast
        case 2:
            self = .accurate
        default:
            self = .balanced
        }
    }
    
}
