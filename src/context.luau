const RunService = game:GetService("RunService")

const RELIABLE_EVENT_NAME = "$reliable"
const UNRELIABLE_EVENT_NAME = "$unreliable"
const FUNCTION_NAME = "$func"

const registry = require("./registry")
const get_packet, get_query = registry.get_packet, registry.get_query

const references = require("./references")
const raw_references, set_references, clear_references =
	references.raw, references.set_references, references.clear_references

const function on_packet(incoming_data: buffer, incoming_refs: { any }, origin_client: Player?)
	const packet_id = buffer.readu8(incoming_data, 0)
	const packet = get_packet(packet_id)

	assert(packet, "unknown packet")

	set_references(incoming_refs)

	const args = { select(2, packet.read(incoming_data, 1)) }

	if origin_client ~= nil then
		table.insert(args, 1, origin_client)
	end

	clear_references()

	for _, callback in packet.listeners do
		task.spawn(callback, unpack(args))
	end
end

const function on_query(incoming_data: buffer, incoming_refs: { any }, origin_client: Player?): buffer
	const query_id = buffer.readu8(incoming_data, 0)
	const query = get_query(query_id)

	assert(query, "unknown query")

	set_references(incoming_refs)

	const args = { select(2, query.args_read(incoming_data, 1)) }

	if origin_client ~= nil then
		table.insert(args, origin_client)
	end

	clear_references()

	const results = query.callback(unpack(args))

	const outgoing_data = buffer.create(query.result_size(unpack(results)))
	query.result_write(outgoing_data, 0, unpack(results))

	return outgoing_data
end

---

export type ContextInformation = {
	reliable_event: RemoteEvent,
	unreliable_event: UnreliableRemoteEvent,

	remote_function: RemoteFunction,
}

const function initialize_server(): ContextInformation
	const reliable_event = Instance.new("RemoteEvent")
	reliable_event.Name = RELIABLE_EVENT_NAME
	reliable_event.Parent = script

	const unreliable_event = Instance.new("UnreliableRemoteEvent")
	unreliable_event.Name = UNRELIABLE_EVENT_NAME
	unreliable_event.Parent = script

	const remote_function = Instance.new("RemoteFunction")
	remote_function.Name = FUNCTION_NAME
	remote_function.Parent = script

	const function on_server_event(client: Player, incoming_data: buffer, incoming_refs: { any }): ()
		on_packet(incoming_data, incoming_refs, client)
	end

	const function on_server_invoke(client: Player, incoming_data: buffer, incoming_refs: { any }): (buffer, { any })
		return on_query(incoming_data, incoming_refs, client), raw_references
	end

	reliable_event.OnServerEvent:Connect(on_server_event)
	unreliable_event.OnServerEvent:Connect(on_server_event)
	remote_function.OnServerInvoke = on_server_invoke

	return {
		reliable_event = reliable_event,
		unreliable_event = unreliable_event,

		remote_function = remote_function,
	}
end

const function initialize_client(): ContextInformation
	const reliable_event = script:WaitForChild(RELIABLE_EVENT_NAME) :: RemoteEvent
	const unreliable_event = script:WaitForChild(UNRELIABLE_EVENT_NAME) :: UnreliableRemoteEvent
	const remote_function = script:WaitForChild(FUNCTION_NAME) :: RemoteFunction

	const function on_client_event(raw_data: buffer, references: { any })
		on_packet(raw_data, references, nil)
	end

	const function on_client_invoke(raw_data: buffer, references: { any }): (buffer, { any })
		return on_query(raw_data, references, nil), raw_references
	end

	reliable_event.OnClientEvent:Connect(on_client_event)
	unreliable_event.OnClientEvent:Connect(on_client_event)
	remote_function.OnClientInvoke = on_client_invoke

	return {
		reliable_event = reliable_event,
		unreliable_event = unreliable_event,

		remote_function = remote_function,
	}
end

const function agnostic_initialize(): ContextInformation
	if RunService:IsServer() then
		return initialize_server()
	end

	return initialize_client()
end

return agnostic_initialize
