tool
extends TileSet

const TILE1 = 0
const TILE2 = 1
const TILE3 = 2
const TILE4 = 3

var binds = {
	TILE1 : [TILE2,TILE3,TILE4],
	TILE2 : [TILE1,TILE4,TILE3],
	TILE3 : [TILE1,TILE2],
	TILE4 : [TILE2,TILE1]
}

func _is_tile_bound(drawn_id: int, neighbor_id: int) -> bool:
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
