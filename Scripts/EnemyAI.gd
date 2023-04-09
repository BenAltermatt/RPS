extends Node
var rng = RandomNumberGenerator.new()
enum {ROCK, PAPER, SCISSORS, CHEAT}
enum {WIN, LOSE, TIE, DQ}
enum {INTRO, MID, WINNER, LOSER}
var history = [[ROCK, PAPER, LOSE], [ROCK, ROCK, TIE],[ROCK, SCISSORS, WIN]]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func op_throw(op, history):
	rng.randomize()
	match op.id:
		1:
			return ROCK
		2:
			#return rng.randi_range(ROCK, PAPER)
			return ROCK
		3:
			print(op.id)
			if ( history.size() < 1 ):
				rng.randi_range(ROCK, SCISSORS)
			var last_array = history[history.size() - 1]
			
			var last_player_move = last_array[0]
			var last_enemy_move = last_array[1]
			var last_outcome = last_array[2]
			
			if (last_outcome == WIN ):
				match last_player_move:
					ROCK:
						return PAPER
					SCISSORS:
						return ROCK
					PAPER:
						return SCISSORS
					_:
						return SCISSORS
			
			if (last_outcome == LOSE ):
				match last_enemy_move:
					ROCK:
						return PAPER
					SCISSORS:
						return ROCK
					PAPER:
						return SCISSORS
					_:
						return SCISSORS
						
			return rng.randi_range(ROCK, SCISSORS)

		_:
			return rng.randi_range(ROCK, SCISSORS)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
