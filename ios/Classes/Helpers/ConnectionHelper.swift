import CoreBluetooth
import Network

class ConnectionHelper: NSObject, CBCentralManagerDelegate {
    private var bluetoothManager: CBCentralManager?
    private var bluetoothStateHandler: ((Bool) -> Void)?
    private var internetStateHandler: ((Bool) -> Void)?

    override init() {
        super.init()
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }

    // MARK: - Internet Connectivity
    func onListenInternetStatusChange(handler: @escaping (Bool) -> Void) {
        internetStateHandler = handler
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { path in
            handler(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    func isInternetConnected(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
            monitor.cancel()
        }
        monitor.start(queue: queue)
    }

    // MARK: - Bluetooth Connectivity
    func onListenBluetoothStatusChange(handler: @escaping (Bool) -> Void) {
        bluetoothStateHandler = handler
        // Send current value at register time
        if let bluetoothManager = bluetoothManager {
            handler(bluetoothManager.state == .poweredOn)
        } else {
            handler(false)
        }
    }

    func isBluetoothEnabled(completion: @escaping (Bool) -> Void) {
        if let bluetoothManager = bluetoothManager {
            completion(bluetoothManager.state == .poweredOn)
        } else {
            completion(false)
        }
    }

    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let isBluetoothOn = central.state == .poweredOn
        bluetoothStateHandler?(isBluetoothOn)
    }
}
