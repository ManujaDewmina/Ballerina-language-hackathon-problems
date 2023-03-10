import ballerina/io;

type Record record {
    string employeeId;
    string gasFillUpCount;
    string totalFuelCost;
    string totalGallons;
    string totalMilesAccrued;
};

function processFuelRecords(string inputFilePath, string outputFilePath) returns error? {
        //read the input xml file
    xml xmlData = check io:fileReadXml(inputFilePath);

    //create string array
    string[] uniqueId = [];

    //iterate through the xml file to get uniqui id array
    foreach var item in xmlData.elementChildren() {
        string id = check item.employeeId;
        boolean isDuplicate = false;
        foreach string j in uniqueId {
            if (id == j) {
                isDuplicate = true;
                break;
            }
        }
        if (!isDuplicate) {
            uniqueId.push(id);
        }
    }

    //store data in records for each unique id
    Record[][] records = [];
    foreach string id in uniqueId {
        Record[] record_a = [];
        int count = 0;
        float totalFuelCost = 0;
        float totalGallons = 0;
        int totalMilesAccrued = 0;
        int first_meter_reading = 0;
        foreach var item in xmlData.elementChildren() {
            string employeeId = check item.employeeId;
            if (id == employeeId) {
                if(count == 0)
                {
                    first_meter_reading = check int:fromString(item.elementChildren().get(0).data());
                }
                count = count + 1;
                totalFuelCost = totalFuelCost + check float:fromString(item.elementChildren().get(1).data())*check float:fromString(item.elementChildren().get(2).data());
                totalGallons = totalGallons + check float:fromString(item.elementChildren().get(1).data());
                totalMilesAccrued = check int:fromString(item.elementChildren().get(0).data()) - first_meter_reading;
            }            
        }
        Record rec = {
                    employeeId: id,
                    gasFillUpCount: count.toString(),
                    totalFuelCost: totalFuelCost.toString(),
                    totalGallons: totalGallons.toString(),
                    totalMilesAccrued: totalMilesAccrued.toString()
                };
                record_a.push(rec);
        records.push(record_a);
    }

    //convert 2D array to 1D array
    Record[] record_c = [];

    //iterate through the records array to get the final records
    foreach Record[] record_b in records {
        foreach Record record_a in record_b {
            Record rec = {
                    employeeId: record_a.employeeId,
                    gasFillUpCount: record_a.gasFillUpCount,
                    totalFuelCost: record_a.totalFuelCost,
                    totalGallons: record_a.totalGallons,
                    totalMilesAccrued: record_a.totalMilesAccrued
                };
                record_c.push(rec);
        }
    }

    //create a new xml file
    xml newXml = xml `<s:employeeFuelRecords xmlns:s="http://www.so2w.org">${from var {employeeId, gasFillUpCount, totalFuelCost, totalGallons, totalMilesAccrued} in record_c select xml`<s:employeeFuelRecord employeeId="${employeeId}"><s:gasFillUpCount>${gasFillUpCount}</s:gasFillUpCount><s:totalFuelCost>${totalFuelCost}</s:totalFuelCost><s:totalGallons>${totalGallons}</s:totalGallons><s:totalMilesAccrued>${totalMilesAccrued}</s:totalMilesAccrued></s:employeeFuelRecord>`}</s:employeeFuelRecords>`;
    
    //write the new xml file
    check io:fileWriteXml(outputFilePath, newXml);
}
