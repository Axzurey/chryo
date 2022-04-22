import { DataStoreService } from "@rbxts/services";
import radonCode from "./errors";

namespace datastore {
    /**
     * returns 0 if it saves successfully, otherwise, 1
     */
    export function save(key: string, datastore: string, value: any) {
        let store = DataStoreService.GetDataStore(datastore);
        try {
            store.SetAsync(key, value);
            return radonCode.success;
        }
        catch(e) {
            let err = e as string;
            if (err.find('403')) {
                return radonCode.noApiAccess;
            }
            return radonCode.unexpected;
        }
    }
    export function load<dataType>(key: string, datastore: string, defaultValue?: dataType): dataType | radonCode {
        let store = DataStoreService.GetDataStore(datastore);
        try {
            return store.GetAsync(key) as dataType;
        }
        catch(e) {
            let err = e as string;
            if (err.find('403')) {
                return radonCode.noApiAccess;
            }
            return defaultValue? defaultValue: radonCode.noData;
        }
    }
}

export = datastore;