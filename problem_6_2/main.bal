import ballerina/websocket;

public map<websocket:Caller[]> riderRequestedLocationMap = {};

service /buggy on new websocket:Listener(9092) {
    resource function get . (string name) returns websocket:Service|websocket:UpgradeError|error {
        return <buggyService|websocket:UpgradeError> trap new buggyService(name);
    }
}

public boolean updateToWAfterChanging = false;

service class buggyService {
    *websocket:Service;
    private final string name;

    public function init(string name) {
        if riderRequestedLocationMap.hasKey(name) {
            panic error websocket:UpgradeError(string `User ${name} is already registered`);
        }

        self.name = name;
    }

    remote function onOpen(websocket:Caller caller) {
        riderRequestedLocationMap[self.name] = [caller];
    }

    remote function onMessage(websocket:Caller caller, string buildingId) returns error? {
        // UPDATE rider
        
    }

    remote function onClose(websocket:Caller caller) returns error? {
        //[websocket:Caller?, string[]] entry = riderRequestedLocationMap.get(self.name);
        //entry[0] = ();
        check caller->close(timeout = 2);
    }
}
type RiderDetails record {|
    string time;
    string rider;
    string buildingId;
|};

table<RiderDetails> dailyRiders = table [];

type DriverDetails record {|
    string time;
    string driver;
    string buildingId;
|};

table<DriverDetails> dailyDrivers = table [];
