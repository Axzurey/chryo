import connection from "shared/modules/connection"
import datastore from "./datastore"
import radonCode from "./errors"
import { model as _model } from "./model";
import { schema as _schema } from "./schema";

namespace radon {
	export const schema = _schema;
	export const model = _model;

	export const Types = radonTypes.Types
}

export = radon;