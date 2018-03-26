type Light
	position::Vec3f
	color::Vec4f
	brightness::Vec4f
	
	Light(position=Vec3f(),color=Vec4f(),brightness=ones(Vec4f)) = new(position,color,brightness)
end

getLightData(light::Light) = [
	light.position.x,light.position.y,light.position.z,
	light.color.x,light.color.y,light.color.z,light.color.a,
	light.brightness.x,light.brightness.y,light.brightness.z,light.brightness.a
	]