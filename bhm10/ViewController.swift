//  Created by Jessica Joseph on 4/17/18.
//  Copyright © 2018 TFH. All rights reserved.

import CoreBluetooth
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items = [String: [String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath) as! BluetoothCell
        cell.signalLabel.text = "Sample"
        
        cell.layer.cornerRadius = 15
        return cell
    }
}

extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
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
