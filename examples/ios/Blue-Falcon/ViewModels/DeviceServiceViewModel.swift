//
//  DeviceServiceViewModel.swift
//  Blue-Falcon
//
//  Created by Andrew Reed on 24/08/2019.
//  Copyright © 2019 Andrew Reed. All rights reserved.
//

import SwiftUI
import library
import Combine
import CoreBluetooth

class DeviceServiceViewModel: NSObject, BlueFalconDelegate, ObservableObject {

    let service: CBService
    let device: CBPeripheral
    var characteristics: [CBCharacteristic] = []
    @Published var deviceCharacteristicCellViewModels: [DeviceCharacteristicCellViewModel] = []

    init(service: CBService, device: CBPeripheral) {
        self.service = service
        self.device = device
        self.characteristics = service.characteristics ?? []
        super.init()
        createViewModelsFromCharacteristics()
        //addDelegate()
    }

    func addDelegate() {
        //AppDelegate.instance.blueFalcon.delegates.add(self)
    }

    func removeDelegate() {
        //AppDelegate.instance.blueFalcon.delegates.remove(self)
    }

    func didDiscoverDevice(bluetoothPeripheral: CBPeripheral) {}

    func didConnect(bluetoothPeripheral: CBPeripheral) {}

    func didDisconnect(bluetoothPeripheral: CBPeripheral) {}

    func didDiscoverServices(bluetoothPeripheral: CBPeripheral) {}

    func didDiscoverCharacteristics(bluetoothPeripheral: CBPeripheral) {
        guard isSameDevice(bluetoothPeripheral),
            let characteristics = service.characteristics else { return }
        print("didDiscoverCharacteristics \(characteristics)")
        self.characteristics = characteristics
        createViewModelsFromCharacteristics()
    }

    func didCharacteristcValueChanged(bluetoothPeripheral: CBPeripheral, bluetoothCharacteristic: CBCharacteristic) {
        print("didCharacteristcValueChanged - \(String(describing: bluetoothCharacteristic.value))")
        createViewModelsFromCharacteristics()
    }

    private func createViewModelsFromCharacteristics() {
        deviceCharacteristicCellViewModels = characteristics.map { characteristic -> DeviceCharacteristicCellViewModel in
            DeviceCharacteristicCellViewModel(
                id: characteristic.uuid,
                characteristic: characteristic,
                device: device
            )
        }
    }

    private func isSameDevice(_ bluetoothPeripheral: CBPeripheral) -> Bool {
        return device.identifier == bluetoothPeripheral.identifier
    }

}
