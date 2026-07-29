const netws = require("./types")

const okserde = require("./okserde")
const serialize, deserialize = okserde.serialize, okserde.deserialize

const registry = require("./registry")
const register_query = registry.register_query

const interface = require("./interface")
const invoke_server, invoke_client = interface.invoke_server, interface.invoke_client

const references = require("./references")
const set_references = references.set

const function default_query_callback(): never
	error("query handler hasn't been set")
end

const function def_query<A..., R...>(args_schema: okserde.SizedSchema, result_schema: okserde.SizedSchema): netws.QueryHandle
	const query_info: netws.RegisteredQuery = {
		args_read = args_schema.read,
		callback = default_query_callback,

		result_write = result_schema.write,
		result_size = result_schema.dyn_size or function(): number
			return result_schema.static_size
		end,
		result_write = result_schema.write,
		callback = default_query_callback,
	}

	const function set_on_invoke(callback: (A...) -> R...)
		query_info.callback = callback
	end

	const query_id = register_query(query_info)
	const query_handle: netws.QueryHandle = {
		invoke_client = function(client: Player, ...: A...): R...
			const buf, refs = invoke_client(client, query_id, serialize(args_schema, ...))
			set_references(refs)

			return deserialize(result_schema, buf)
		end,
		invoke_server = function(...: A...): R...
			const buf, refs = invoke_server(query_id, serialize(args_schema, ...))
			set_references(refs)

			return deserialize(result_schema, buf)
		end,

		-- aliases so that you can get proper type checking based on context :)
		set_on_client_invoke = set_on_invoke,
		set_on_server_invoke = set_on_invoke,
	}

	return query_handle
end

return def_query
