//  Created by Jessica Joseph on 4/17/18.
//  Copyright © 2018 TFH. All rights reserved.

import CoreBluetooth
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = [String: [String:Any]]()
    
    var devices: Dictionary<String, CBPeripheral> = [:]
    var activeCentralManager: CBCentralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        activeCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath) as! BluetoothCell
        
        let discoveredPeripherals = Array(devices.values)
        
            if let name = discoveredPeripherals[indexPath.row].name {
                cell.signalLabel.text = name
            }
        
        cell.layer.cornerRadius = 15
            return cell
    }
}

extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            if central.state == .poweredOn {
                central.scanForPeripherals(withServices: nil, options: nil)
                print("Searching for BLE Devices")
            } else {
                print("Bluetooth switched off")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            if (devices[name] == nil) {
                devices[name] = peripheral
                self.tableView.reloadData()
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.readRSSI()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let name = peripheral.name {
            items[name] = [
                "name": name,
                "rssi": RSSI
            ]
        }
        
        tableView.reloadData()
    }
}
