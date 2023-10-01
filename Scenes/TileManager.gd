extends TileMap
class_name TileManager

static var AirMaskID : int = 2
var BlockLayerArray = [0]

static var BlackMask : Vector3i = Vector3i(2,0,0)
static var main : TileManager

static var TileTypeDictionary = {}
var TileDictionary : Dictionary = Dictionary()

var timer : float
@export var TickInterval : float = 1

class MapBlockBehaviour:
	extends Node
	var Coordinate : Vector3i
	var TextureCoordinate : Vector3i
	var Air : bool
	var PreviousAir : bool
	
	var Burnable : bool = false
	
	func CheckAir():
		Air = TileManager.main.get_cell_tile_data(TileManager.AirMaskID,GetPlaneCoordinate()) == null
	
	func GetPlaneCoordinate() -> Vector2i:
		return Vector2i(Coordinate.x,Coordinate.y)
	
	func _init(coordinate : Vector3i,textureCoordinate : Vector3i):
		Coordinate = coordinate
		TextureCoordinate = textureCoordinate
		CheckAir()
		PreviousAir =! Air
		Define()
		
	func Define():
		return
	
	func BlockTick():
		CheckAir()
		ConstantBehaviour()

		if Air != PreviousAir:
			if Air : 
				OnAirOccupyBehaviour()
			else:
				OnAirExitBehaviour()
			PreviousAir = Air

		if Air:
			OnAirOccupyingBehaviour()
			return

		WithoutAirBehaviour()

	static func GetTextureCoordinate() -> Vector3i:
		return Vector3i.ZERO

	func TickBehaviour():
		return

	func OnAirOccupyingBehaviour():
		return

	func OnAirOccupyBehaviour():
		return
		
	func OnAirExitBehaviour():
		return

	func WithoutAirBehaviour():
		return

	func ConstantBehaviour():
		return
		#if TileManager.main.GetBlock(Coordinate + Vector3i.DOWN) == null:
			#TileManager.main.SetBlock(Coordinate + Vector3i.DOWN,self)

class BrickBlock extends TileManager.MapBlockBehaviour:
	func define():
		Burnable = true
	func OnAirOccupyingBehaviour():
		#TileManager.main.SetAir(Vector2i(Coordinate.y,Coordinate.z),false)
		return
		
func _ready():
	main = self
	LoadMapTile()

func _process(delta):
	timer += delta
	if timer > TickInterval :
		timer = 0
		for value in TileDictionary.values():
			value.BlockTick()
		RendererBlock()
		print_debug("Tick")
	
func LoadMapTile():
	for layer in BlockLayerArray:
		for coordinate in get_used_cells(layer):
			var layercord = Vector3i(coordinate.x,coordinate.y,layer)
			var textureCoodinate = get_cell_atlas_coords(layer,coordinate) 
			TileDictionary[layercord] = BrickBlock.new(layercord,Vector3i(get_cell_source_id(layer,coordinate),textureCoodinate.x,textureCoodinate.y))
			
func SetBlock(cord : Vector3i,block : MapBlockBehaviour):
	TileDictionary[cord] = block
	TileDictionary.erase(block.Coordinate)
	block.Coordinate = cord
	
func GetBlock(cord : Vector3i) -> MapBlockBehaviour:
	if TileDictionary.has(cord):
		return TileDictionary[cord]
	return null
	
func HasAir(cord : Vector2i) -> bool:
	return TileManager.main.get_cell_tile_data(AirMaskID,cord) == null
	
func SetAir(cord : Vector2i,air : bool):
	if air:
		set_cell(AirMaskID,cord)
	else:
		set_cell(AirMaskID,cord,BlackMask.x,Vector2i(BlackMask.y,BlackMask.z))
		
func RendererBlock():
	for layer in BlockLayerArray:
		clear_layer(layer)
	for block in TileDictionary.values():
		set_cell(block.Coordinate.z,block.GetPlaneCoordinate(),block.TextureCoordinate.x,Vector2i(block.TextureCoordinate.y,block.TextureCoordinate.z))
	return
