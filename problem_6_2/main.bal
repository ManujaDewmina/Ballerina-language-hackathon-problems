import ballerina/io;
import ballerina/websocket;

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

public function main() returns error? {
    tes
}
