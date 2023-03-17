import ims/billionairehub;
import ballerina/io;

configurable string clientId = ?; 
configurable string clientSecret = ?;

//record to store the billionaire details
type BillionaireRec record {
    string name;
    float netWorth;
};

public function getTopXBillionaires(string[] countries, int x) returns string[]|error {
    // Create the client connector
    billionairehub:Client cl = check new ({auth: {clientId, clientSecret}});

    //create an array to store the top x billionaires
    string[] AllBillionaires = [];
    
    // record array
    BillionaireRec[] billionairesRec = [];

    //loop through the countries and get the top x billionaires
    foreach string country in countries {
        //get the billionaires from the API
        io:print(country);
        billionairehub:Billionaire[] billionaires = check cl->getBillionaires(country);

        //loop through the billionaires and add them to the record
        foreach billionairehub:Billionaire billionaire in billionaires {
            BillionaireRec billionaireRec = {name: billionaire.name, netWorth: billionaire.netWorth};
            billionairesRec.push(billionaireRec);
        }   
    }

    //loop through the record array and get the top x billionaires
    foreach BillionaireRec billionaire in billionairesRec {
        if (billionairesRec.length() < x) {
            AllBillionaires.push(billionaire.name);
        }
    }

    //strimg array
    return AllBillionaires;
}