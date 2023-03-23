import ballerina/websocket;
// import ballerina/io;

enum Location {
    R, S, T, U, V, W
}

function negotiatePickUp(string url, string name, Location location) returns [Location, Location]|error {

    // Create a new WebSocket client.
    websocket:Client wsClient = check new(url+"?name="+name);

    check wsClient->writeTextMessage(location.toString());

    string|error? shuttleLocation = wsClient->readTextMessage();

    if (shuttleLocation == "W" || location.toString() == "W" || location.toString() == "Q")
    {
        error err = error("Shuttle error");
        return err;
    } else  if (shuttleLocation == "R" && (location.toString() == "S" || location.toString() == "V" )) {
        return [location, shuttleLocation];
    } else if (shuttleLocation == "T" && (location.toString() == "U" || location.toString() == "V" )) {
        return [location, shuttleLocation];
    } else if (shuttleLocation == "S" && ( location.toString() == "V" )) {
        return [location, shuttleLocation];
    } else if (shuttleLocation == "U" && ( location.toString() == "V" )) {
        return [location, shuttleLocation];
    } else if (shuttleLocation == "R" && ( location.toString() == "T" || location.toString() == "U")) {
        check wsClient->writeTextMessage("V");
        Location lo = V;
        return [lo, shuttleLocation];
    } else if (shuttleLocation == "S" && ( location.toString() == "T" || location.toString() == "U")) {
        check wsClient->writeTextMessage("V");
        Location lo = V;
        return [lo, shuttleLocation];
    } else if (shuttleLocation == "T" && ( location.toString() == "R" || location.toString() == "S")) {
        check wsClient->writeTextMessage("V");
        Location lo = V;
        return [lo, shuttleLocation];
    } else if (shuttleLocation == "U" && ( location.toString() == "R" || location.toString() == "S")) {
        check wsClient->writeTextMessage("V");
        Location lo = V;
        return [lo, shuttleLocation];
    } else if (shuttleLocation == "V" && ( location.toString() == "R" || location.toString() == "S" || location.toString() == "T" || location.toString() == "U")) {
        error err = error("Shuttle passed");
        websocket:Error? close = wsClient->close(timeout = 2);
        if close is websocket:Error {
            return err;
        }
    } else if (shuttleLocation == "S" && ( location.toString() == "R")) {
        error err = error("Shuttle passed");
        websocket:Error? close = wsClient->close(timeout = 2);
        if close is websocket:Error {
            return err;
        }
    } else if (shuttleLocation == "U" && ( location.toString() == "T")) {
       error err = error("Shuttle passed");
        websocket:Error? close = wsClient->close(timeout = 2);
        if close is websocket:Error {
            return err;
        }
    }
    error err = error("Error");
    return err;
}
