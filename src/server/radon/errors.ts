enum radonCode {
    success = "task completed successfully",
    noApiAccess = "unable to connect to datastore api. Is it enabled in game settings?",
    unexpected = "An unexpected error occured",
    objectCanNotBeSerialized = "Objects of type [x] can not be serialized",
    noData = "No data has been saved to this key"
}

export = radonCode;