const okserde = require("@self/lib/okserde")
const schemas = okserde.schemas
const specs = okserde.specs

const okserde_rbx = require("@self/lib/okserde/rbx")

return {
	def_packet = require("@self/def_packet"),
	def_query = require("@self/def_query"),

	schemas = {
		boolean = schemas.boolean,
		buffer = schemas.buffer,
		null = schemas.null,
		number = schemas.number,
		string = schemas.string,
		vector = schemas.vector,

		array = schemas.array,
		optional = schemas.optional,
		struct = schemas.struct,
		tuple = schemas.tuple,
		union = schemas.union,

		bitarray = schemas.bitarray,
		bitstruct = schemas.bitstruct,
		flags = schemas.flags,
		literalvariant = schemas.literalvariant,
		termstring = schemas.termstring,
		void = schemas.void,

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
	specs = specs,
}
