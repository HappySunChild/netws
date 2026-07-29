const netws = require("./types")

const okserde = require("./okserde")
const serialize, deserialize = okserde.serialize, okserde.deserialize

const registry = require("./registry")
const register_query = registry.register_query

const interface = require("./interface")
const invoke_server, invoke_client = interface.invoke_server, interface.invoke_client

const function default_query_callback()
	error("query handler hasn't been set")
end

const function def_query<A..., R...>(args_schema: okserde.Schema, result_schema: okserde.Schema): netws.QueryHandle
	const info: netws.RegisteredQuery = {
		args_read = args_schema.read,
		result_alloc = result_schema.alloc_size,
		result_write = result_schema.write,
		callback = default_query_callback,
	}

	const query_id = register_query(info)

	const query_handle: netws.QueryHandle = {
		invoke_client = function(client: Player, ...: A...): R...
			return deserialize(result_schema, invoke_client(client, query_id, serialize(args_schema, ...)))
		end,
		invoke_server = function(...: A...): R...
			return deserialize(result_schema, invoke_server(query_id, serialize(args_schema, ...)))
		end,

		set_on_invoke = function(callback: (A...) -> R...)
			info.callback = callback
		end,
	}

	return query_handle
end

return def_query
