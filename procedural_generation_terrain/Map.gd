extends TileMap
class_name MapProcGen

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

var width = ProjectSettings.get("display/window/size/viewport_width") / 8 + 4
var height = ProjectSettings.get("display/window/size/viewport_height") / 8 + 4

var gen_position : Vector2

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
func set_gen_pos(position):
	gen_position = position
	
func update_position(position):
	gen_position = position	

func update_size(screen_size : Vector2i):
	width = screen_size.x / 8 + 4
	height = screen_size.y / 8 + 4
	pass
	
func _process(delta):
	if (gen_position != null):
		generate_chunk(gen_position)

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	
	for x in range(width):
		for y in range(height):
			var x_offset : float = tile_pos.x - width/2 + x
			var y_offset : float = tile_pos.y - height/2 + y
			
			# get_noise_2d génère une valeur entre -1 et 1
			# amplification avec un facteur de 10 pour obtenir -10 à 10
			var moist = moisture.get_noise_2d(x_offset, y_offset) * 10
			var temp = temperature.get_noise_2d(x_offset, y_offset) * 10
			var alt = altitude.get_noise_2d(x_offset, y_offset) * 10
			
			# déplace la valeur de 10 pour n'obtenir que des valeurs positives
			# divise par 5 pour avoir des valeur entre 0 et 3 pour l'index
			# de la colonne et rangée
			var tile_x = round(moist + 10) / 5
			var tile_y = round(temp + 10) / 5
			
			if (alt < -1):
				set_cell(0, Vector2i(x_offset, y_offset), 0, Vector2(3, tile_y))
			else:
				set_cell(0, Vector2i(x_offset, y_offset), 0, Vector2(tile_x, tile_y))
