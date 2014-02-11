require 'FileUtils'

# -------

head_of_ducument = '{"type": "FeatureCollection", "features": [ '
tail_of_document = ']}'


# Delta / Subdivides
# deltas in the 1/1000 produce a noticeable max-zoom difference.
coord_delta = 0.0001
to_generate = ARGV[1]
center_coord_x = ARGV[2]
center_coord_y = ARGV[3]

if ARGV[0] == "triangles"
	jsonFileName = "triangles.geojson"
	triangles = File.open(jsonFileName, "w");
	triangles.puts(head_of_ducument)

	to_generate.to_i.times do |coord_delta, center_coord_x, center_coord_y|
		puts coord_delta + " is d, " + center_coord_x + ", " + center_coord_y + " is coord"

		coord_p1_x = center_coord_x
		coord_p1_y = center_coord_y + coord_delta
		coord_p2_x = center_coord_x - coord_delta
		coord_p2_y = center_coord_y - coord_delta
		coord_p3_x = center_coord_x + coord_delta
		coord_p3_y = center_coord_y + coord_delta
		center_coord_x += 2 * coord_delta
		center_coord_y += 2 * coord_delta

		triangles.puts('{"geometry": {"coordinates": [[')
		triangles.puts('[' + coord_p1_x + ', ' + coord_p1_y + '], ')
		triangles.puts('[' + coord_p2_x + ', ' + coord_p2_y + '], ')
		triangles.puts('[' + coord_p3_x + ', ' + coord_p3_y + '], ')
		triangles.puts('[' + coord_p1_x + ', ' + coord_p1_y + ']]]}')
	end

	triangles.puts(tail_of_document)
end
