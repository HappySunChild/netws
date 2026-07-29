const RunService = game:GetService("RunService")

const registry = require("./registry")
const get_packet, get_query = registry.get_packet, registry.get_query

const references = require("./references")
const set_references = references.set

export type ContextInformation = {
	remote_event: RemoteEvent,
	unreliable_remote_event: UnreliableRemoteEvent,
	remote_function: RemoteFunction,
}

const function on_packet(raw_data: buffer, refs: { any }, client: Player?)
	const packet_id = buffer.readu8(raw_data, 0)
	const packet = get_packet(packet_id)

	assert(packet, "unknown packet")

	set_references(refs)

	const args = { select(2, packet.read(raw_data, 1)) }

	if client ~= nil then
		table.insert(args, 1, client)
	end

	for _, callback in packet.listeners do
		task.spawn(callback, unpack(args))
	end
end

const function on_query(raw_data: buffer, refs: { any }, client: Player?): buffer
	const query_id = buffer.readu8(raw_data, 0)
	const query = get_query(query_id)

	assert(query, "unknown query")

	set_references(refs)

	const results = {
		if client ~= nil
			then query.callback(client, select(2, query.args_read(raw_data, 1)))
			else query.callback(select(2, query.args_read(raw_data, 1))),
	}

	const b = buffer.create(query.result_alloc(unpack(results)))
	query.result_write(b, 0, unpack(results))

	return b
end

const function initialize_server(): ContextInformation
	const remote_event = Instance.new("RemoteEvent")
	remote_event.Name = "$event"
	remote_event.Parent = script

	const unreliable_remote_event = Instance.new("UnreliableRemoteEvent")
	unreliable_remote_event.Name = "$unreliable_event"
	unreliable_remote_event.Parent = script

	const remote_function = Instance.new("RemoteFunction")
	remote_function.Name = "$func"
	remote_function.Parent = script

	const function on_server_event(client: Player, raw_data: buffer, references: { any }): ()
		on_packet(raw_data, references, client)
	end

	const function on_server_invoke(client: Player, raw_data: buffer, references: { any })
		return on_query(raw_data, references, client)
	end

	remote_event.OnServerEvent:Connect(on_server_event)
	unreliable_remote_event.OnServerEvent:Connect(on_server_event)
	remote_function.OnServerInvoke = on_server_invoke

	return {
		remote_event = remote_event,
		unreliable_remote_event = unreliable_remote_event,
		remote_function = remote_function,
	}
end

const function initialize_client(): ContextInformation
	const remote_event = script:WaitForChild("$event") :: RemoteEvent
	const unreliable_remote_event = script:WaitForChild("$unreliable_event") :: UnreliableRemoteEvent
	const remote_function = script:WaitForChild("$func") :: RemoteFunction

	const function on_client_event(raw_data: buffer, references: { any })
		on_packet(raw_data, references, nil)
	end

	const function on_client_invoke(raw_data: buffer, references: { any })
		return on_query(raw_data, references, nil)
	end

	remote_event.OnClientEvent:Connect(on_client_event)
	unreliable_remote_event.OnClientEvent:Connect(on_client_event)
	remote_function.OnClientInvoke = on_client_invoke

	return {
		remote_event = remote_event,
		unreliable_remote_event = unreliable_remote_event,
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
