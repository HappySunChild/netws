const REFERENCES = {}

const function clear_references()
	table.clear(REFERENCES)
end

const function set_references(new_references: { any }?)
	table.clear(REFERENCES)
	table.move(new_references, 1, #new_references, 1, REFERENCES)
end

return {
	set_references = set_references,
	clear_references = clear_references,
	raw = REFERENCES,
}
