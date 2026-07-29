const okserde = require("@self/okserde")
const schemas = okserde.schemas
const encodings = okserde.encodings

const okserde_rbx = require("@self/okserde/rbx")

const references = require("@self/references")

return {
	def_packet = require("@self/def_packet"),
	def_query = require("@self/def_query"),

	schemas = {
		array = schemas.array,
		bitarray = schemas.bitarray,
		bitstruct = schemas.bitstruct,
		boolean = schemas.boolean,
		buffer = schemas.buffer,
		cstring = schemas.cstring,
		enum = schemas.enum,
		flags = schemas.flags,
		map = schemas.map,
		null = schemas.null,
		number = schemas.number,
		optional = schemas.optional,
		padding = schemas.padding,
		string = schemas.string,
		struct = schemas.struct,
		transientref = schemas.transientref,
		tuple = schemas.tuple,
		union = schemas.union,
		vector = schemas.vector,

		Axes = okserde_rbx.Axes,
		BrickColor = okserde_rbx.BrickColor,
		CFrame = okserde_rbx.CFrame,
		Color3 = okserde_rbx.Color3,
		ColorSequence = okserde_rbx.ColorSequence,
		ColorSequenceKeypoint = okserde_rbx.ColorSequenceKeypoint,
		Content = okserde_rbx.Content,
		DateTime = okserde_rbx.DateTime,
		Enum = okserde_rbx.Enum,
		EnumItem = okserde_rbx.EnumItem,
		Faces = okserde_rbx.Faces,
		Font = okserde_rbx.Font,
		Instance = schemas.transientref(references.raw),
		NumberRange = okserde_rbx.NumberRange,
		NumberSequence = okserde_rbx.NumberSequence,
		NumberSequenceKeypoint = okserde_rbx.NumberSequenceKeypoint,
		PathWaypoint = okserde_rbx.PathWaypoint,
		PhysicalProperties = okserde_rbx.PhysicalProperties,
		Ray = okserde_rbx.Ray,
		Rect = okserde_rbx.Rect,
		Region3 = okserde_rbx.Region3,
		TweenInfo = okserde_rbx.TweenInfo,
		UDim = okserde_rbx.UDim,
		UDim2 = okserde_rbx.UDim2,
		Vector2 = okserde_rbx.Vector2,
		Vector3 = okserde_rbx.Vector3,
	},
	encodings = encodings,
}
