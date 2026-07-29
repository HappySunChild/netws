const types = require("./types")

const REGISTERED_PACKETS: { types.RegisteredPacket } = {}
const REGISTERED_QUERIES: { types.RegisteredQuery } = {}

local packet_count = 0
local query_count = 0

const function register_packet(packet_info: types.RegisteredPacket): number
	assert(packet_count < 256, "can't register more than 255 packets at once")

	const packet_id = packet_count

	REGISTERED_PACKETS[packet_id] = packet_info

	packet_count += 1

	return packet_id
end

const function get_packet(id: number): types.RegisteredPacket?
	return REGISTERED_PACKETS[id]
end

const function register_query(query_info: types.RegisteredQuery): number
	assert(query_count < 256, "can't register more than 255 queries at once")

	const query_id = query_count

	REGISTERED_QUERIES[query_id] = query_info

	query_count += 1

	return query_id
end

const function get_query(id: number): types.RegisteredQuery?
	return REGISTERED_QUERIES[id]
end

return {
	register_packet = register_packet,
	get_packet = get_packet,

	register_query = register_query,
	get_query = get_query,
}
