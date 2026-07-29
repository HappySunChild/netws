export type RegisteredPacket<A... = ...any> = {
	read: (b: buffer, offset: number) -> (number, A...),
	listeners: { [{}]: (A...) -> () },
}

export type RegisteredQuery<A... = ...any, R... = ...any> = {
	args_read: (b: buffer, offset: number) -> A...,
	result_write: (b: buffer, offset: number, R...) -> number,
	result_alloc: (R...) -> number,

	callback: (A...) -> R...,
}

export type PacketHandle<A... = ...any> = {
	fire_server: (A...) -> (),
	fire_server_unreliable: (A...) -> (),

	fire_client: (client: Player, A...) -> (),
	fire_client_unreliable: (client: Player, A...) -> (),
	broadcast: (A...) -> (),
	broadcast_unreliable: (A...) -> (),

	listen: (callback: (A...) -> ()) -> (),
}

export type QueryHandle<A... = ...any, R... = ...any> = {
	invoke_server: (A...) -> R...,
	invoke_client: (client: Player, A...) -> R...,

	set_on_invoke: (callback: (A...) -> R...) -> (),
}

return nil
