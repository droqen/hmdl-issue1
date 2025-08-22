@tool
extends Node
@export var pyxel_file_path : String
@export var button : bool = false: 
	get() : return false
	set(_v) : unzip(pyxel_file_path)

func unzip(path_to_zip_any_ext : String) -> void:
	var zr : ZIPReader = ZIPReader.new()
	var err = zr.open(path_to_zip_any_ext)
	if err == OK:
		var base_dir = path_to_zip_any_ext.get_base_dir()
		for child in get_children():
			if child is Sprite2D:
				child.texture = ''
		var i : int = 0
		for filepath in zr.get_files():
			var filepath_split = filepath.rsplit(".",true,1)
			print(filepath + "...")
			if len(filepath_split) > 1:
				var ext : String = filepath_split[1]
				match ext :
					"json" : 
						print(JSON.new().parse_string(zr.read_file(filepath).get_string_from_utf8()))
					"png" :
						var is_layer : bool = filepath.begins_with("layer")
						if is_layer:
							var img : Image = Image.new()
							img.load_png_from_buffer(zr.read_file(filepath))
							var layerspr = get_spr_or_create("layer"+str(i))
							layerspr.texture = ImageTexture.create_from_image(img)
							
							#var savepath : String = path_to_zip_any_ext.get_base_dir() + "/" + filepath
							#var saveerr = img.save_png(savepath)
							#if saveerr == OK:
								#var layerspr = get_spr_or_create("layer"+str(i))
								#layerspr.texture = load(savepath) as Texture2D
								#layerspr.queue_redraw()
								#i += 1
							#else:
								#print("save failed ",saveerr)
	else:
		print("not ok: %s" % err)

func get_spr_or_create(nodename: String) -> Sprite2D:
	var spr : Sprite2D = get_node_or_null(nodename)
	if spr == null:
		spr = Sprite2D.new()
		spr.name = nodename
		add_child(spr)
		spr.owner = owner if owner else self
	return spr
