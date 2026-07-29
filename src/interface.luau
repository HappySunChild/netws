const references = require("./references")
const raw_references = references.raw

const initialize_context = require("./context")

const info = initialize_context()
local remote_event: RemoteEvent, unreliable_remote_event: UnreliableRemoteEvent, remote_function: RemoteFunction =
	info.remote_event, info.unreliable_remote_event, info.remote_function

const function tag_buffer_with_id(id: number, buf: buffer): buffer
	const tagged_b = buffer.create(buffer.len(buf) + 1)
	buffer.writeu8(tagged_b, 0, id)
	buffer.copy(tagged_b, 1, buf)

	return tagged_b
end

-- client
const function fire_server(packet_id: number, packet_buf: buffer)
	remote_event:FireServer(tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function fire_server_unreliable(packet_id: number, packet_buf: buffer)
	unreliable_remote_event:FireServer(tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function invoke_server(query_id: number, args_buf: buffer): buffer
	return remote_function:InvokeServer(tag_buffer_with_id(query_id, args_buf), raw_references)
end

-- server
const function fire_client(client: Player, packet_id: number, packet_buf: buffer)
	remote_event:FireClient(client, tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function fire_client_unreliable(client: Player, packet_id: number, packet_buf: buffer)
	unreliable_remote_event:FireClient(client, tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function broadcast(packet_id: number, packet_buf: buffer)
	remote_event:FireAllClients(tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function broadcast_unreliable(packet_id: number, packet_buf: buffer)
	unreliable_remote_event:FireAllClients(tag_buffer_with_id(packet_id, packet_buf), raw_references)
end

const function invoke_client(client: Player, query_id: number, args_buf: buffer): buffer
	return remote_function:InvokeClient(client, tag_buffer_with_id(query_id, args_buf), raw_references)
end

return {
	-- client
	fire_server = fire_server,
	fire_server_unreliable = fire_server_unreliable,
	invoke_server = invoke_server,

	-- server
	fire_client = fire_client,
	fire_client_unreliable = fire_client_unreliable,
	broadcast = broadcast,
	broadcast_unreliable = broadcast_unreliable,
	invoke_client = invoke_client,
}
