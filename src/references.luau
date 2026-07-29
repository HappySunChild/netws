const transientref_schema = require("./okserde/schemas/transientref")

const REFERENCES = {}

const function clear()
	table.clear(REFERENCES)
end

const function set(new_references: { Instance })
	table.clear(REFERENCES)
	table.move(new_references, 1, #new_references, 1, REFERENCES)
end

return {
	clear = clear,
	set = set,
	raw = REFERENCES,

	schema = transientref_schema(REFERENCES),
}
