import Flutter

class InternetEventHandler: NSObject, FlutterStreamHandler {
    private let connectionHelper: ConnectionHelper
    private var eventSink: FlutterEventSink?

    init(connectionHelper: ConnectionHelper) {
        self.connectionHelper = connectionHelper
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
        -> FlutterError?
    {
        self.eventSink = events
        connectionHelper.onListenInternetStatusChange { isConnected in
            events(isConnected)
        }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
