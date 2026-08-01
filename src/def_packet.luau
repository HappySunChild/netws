const netws = require("./types")

const okserde = require("./okserde")
const serialize = okserde.serialize

const registry = require("./registry")
const register_packet = registry.register_packet

const interface = require("./interface")
const fire_client, fire_client_unreliable, broadcast, broadcast_unreliable, fire_server, fire_server_unreliable =
	interface.fire_client,
	interface.fire_client_unreliable,
	interface.broadcast,
	interface.broadcast_unreliable,
	interface.fire_server,
	interface.fire_server_unreliable

const function def_packet<A...>(packet_schema: okserde.Schema<A...>): netws.PacketHandle<A...>
	const packet_listeners = {}

	const function listen(callback: (A...) -> ())
		const unique_id = {}

		packet_listeners[unique_id] = callback

		return function()
			packet_listeners[unique_id] = nil
		end
	end

	const packet_id = register_packet({ listeners = packet_listeners, read = packet_schema.read })
	const packet_handle: netws.PacketHandle = {
		fire_client = function(client: Player, ...: A...)
			fire_client(client, packet_id, serialize(packet_schema, ...))
		end,
		fire_client_unreliable = function(client: Player, ...: A...)
			fire_client_unreliable(client, packet_id, serialize(packet_schema, ...))
		end,
		broadcast = function(...: A...)
			broadcast(packet_id, serialize(packet_schema, ...))
		end,
		broadcast_unreliable = function(...: A...)
			broadcast_unreliable(packet_id, serialize(packet_schema, ...))
		end,

		fire_server = function(...: A...)
			fire_server(packet_id, serialize(packet_schema, ...))
		end,
		fire_server_unreliable = function(...: A...)
			fire_server_unreliable(packet_id, serialize(packet_schema, ...))
		end,

		-- aliases so that you can get proper type checking based on context :)
		listen_on_client = listen,
		listen_on_server = listen,
	}

	return packet_handle
end

return def_packet
