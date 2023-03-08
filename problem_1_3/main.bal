import ballerina/io;

type Record record {
    int employeeId;
    int odometerReading;
    float gallons;
    float gasPrice;
};

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
    json input = check io:fileReadJson(inputFilePath);
    // The `cloneWithType` method is used to clone the `json` value and convert it to the specified type.
    Record records = check input.cloneWithType(Record);

    io:print("Employee ID: ", records.employeeId);
}
