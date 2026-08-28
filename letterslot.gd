extends Node2D
class_name LetterSlot


@export var slot_index: int = 0        ## position in the word, left to right, 0-based
@export var accepted_letter: String = ""  ## the correct letter for this slot (for reference/debug)

var current_tile: LetterTile = null

func is_filled() -> bool:
	return current_tile != null
