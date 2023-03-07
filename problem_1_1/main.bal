
function allocateCubicles(int[] requests) returns int[] {
    //check if requests is empty
    if (requests.length() == 0) {
        return [];
    }

    //check if request have duplicates and remove them
    int[] uniqueRequests = [];

    foreach int i in requests{
        boolean isDuplicate = false;
        foreach int j in uniqueRequests {
            if (i == j) {
                isDuplicate = true;
                break;
            }
        }
        if (!isDuplicate) {
            uniqueRequests.push(i);
        }
    }
    return uniqueRequests.sort();
}