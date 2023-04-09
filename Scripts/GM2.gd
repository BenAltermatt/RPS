extends Node

# these are the signals to continue the game loop
signal round_fin			# a single round has been completed and we can continue to the next
signal speaking_fin			# the player has finished speaking
signal throw_fin			# the throwing sequence has completed
signal move_fin				# the animation of the throws has finished



enum {ROCK, PAPER, SCISSORS, CHEAT}
enum {WIN, LOSE, TIE, DQ}
enum {INTRO, MID, WINNER, LOSER}

const MAX_MEM = 100 # you can remember the previous 100 throws
const MAX_FOCUS = 9
const MIN_FOCUS = 0
const MAX_CHEAT = .6
const MIN_CHEAT = .25
const PLAYER_HEALTH = 3
const CHEAT_PENALTY = 2
const LOSS_PENALTY = 1
const RPS_DELAY = 1
const GRACE_PD = .1
const SPRITE_PATH = "res://Assets/Sprites/"

var Opponent = load("res://Scripts/Opponent.gd")
var MoveSelect
var PlayerHealth
var OpHealth
var Talking
var OpponentSprite
var rng = RandomNumberGenerator.new()

var round_history = []
var cur_throw = -1
var p_health = PLAYER_HEALTH
var cur_op


func _ready():
	cur_op = GLSingleton.ops[GLSingleton.cur_op_ind]

	Talking = $Talking 				# the talking object
	PlayerHealth = $PlayerHealth	# health object for player
	OpHealth = $OpHealth			# health object for opponent
	MoveSelect = $MoveSelect		# move selection menu
	OpponentSprite = $Opponent		# this is the opponent sprite

	# connect to the throw clicked singals in the children
	var temp = get_node("MoveSelect/TextureRect/Control").get_children()
	for child in temp:
		child.connect("throw_clicked", self, "_handle_throw")

	full_match()
	

func full_match():
	# set player and op health
	PlayerHealth.update_health(PLAYER_HEALTH, p_health)
	OpHealth.update_health(cur_op.health, cur_op.cur_health)

	# update the sprites
	OpponentSprite.set_texture(SPRITE_PATH + cur_op.anim_path + ".png")


	say(cur_op, INTRO)
	yield(self, "speaking_fin")

	while p_health > 0 and cur_op.cur_health > 0:
		play_round()
		yield(self, "round_fin")

	# register a win or loss
	var won
	if p_health > 0:
		say(cur_op, LOSER)
		won = true
	else:
		say(cur_op, WINNER)
		won = false
	yield(self, "speaking_fin")

	GLSingleton.next_enemy(won)

func play_round():
	player_move()
	yield(self, "throw_fin")

	var caught = false
	var threw = true
	match cur_throw:
		-1: 
			caught = true
			threw = false
		CHEAT: 
			var roll = rng.randf()
			print("Cheat prob %f" % (cur_op.focus * (MIN_CHEAT - MAX_CHEAT) / (MAX_FOCUS - MIN_FOCUS) + MIN_CHEAT))
			print("Rolled %f" % roll)
			caught = cur_op.focus * (MAX_CHEAT - MIN_CHEAT) / (MIN_FOCUS - MAX_FOCUS) + MAX_CHEAT < roll
			print(caught)

	var op_move = op_throw(cur_op, round_history)

	if cur_throw == CHEAT:
		cur_throw = cheat_play(op_move)
	
	# calculate the results
	var results = null
	
	if caught:
		results = DQ
	else:
		results = play_throw(cur_throw, op_move)

	# render the moves
	render_moves(cur_throw, op_move, threw, results)
	yield(self, "move_fin")

	print("Progressed")

	# handle caught cheating consequences
	if caught:
		say(cur_op, MID)
		yield(self, "speaking_fin")
		
		if threw: # on purpose
			p_health -= CHEAT_PENALTY
			cur_op.cur_health += LOSS_PENALTY
			PlayerHealth.update_health(PLAYER_HEALTH, p_health)
			OpHealth.update_health(cur_op.health, cur_op.cur_health)

	emit_signal("round_fin")
	

func player_move():
	# Ready set go function would be here
	cur_throw = -1
	ready_set_go()

# displays / runs the ready_set_go signs and catalogs a throw
# returns when finished
func ready_set_go():
	print("ROCK")
	yield(get_tree().create_timer(RPS_DELAY), "timeout")
	print("PAPER")
	yield(get_tree().create_timer(RPS_DELAY), "timeout")
	print("SCISSORS")
	yield(get_tree().create_timer(RPS_DELAY), "timeout")
	print("SHOOT")
	yield(get_tree().create_timer(GRACE_PD), "timeout")
	emit_signal("throw_fin")

# this should render the moves taking place
func render_moves(p_move, op_move, threw, result):
	print("Player does %d. Op does: %d. Result: %d" % [p_move, op_move, result])
	temp_health_update(threw, result)
	yield(get_tree().create_timer(.5), "timeout")
	emit_signal("move_fin")

# this will update the health according to what would
# happen if the player always succeeded when cheating
func temp_health_update(threw, result):
	match result:
		WIN: cur_op.cur_health -= LOSS_PENALTY
		LOSE: p_health -= LOSS_PENALTY
		DQ: 
			if not threw: 
				p_health -= CHEAT_PENALTY
			else:
				cur_op.cur_health -= LOSS_PENALTY
	
	PlayerHealth.update_health(PLAYER_HEALTH, p_health)
	OpHealth.update_health(cur_op.health, cur_op.cur_health)


# this just speaks a character's lines.
# signals when finished
func say(cur_op, context):	
	flip_ui()
	yield(Talking, "flipped")

	# now we want to talk
	match context:
		INTRO: 
			Talking.speak(cur_op.intros)
			yield(Talking, "completed_typing")
		MID:
			Talking.speak(cur_op.mids)
			yield(Talking, "completed_typing")
		WINNER:
			Talking.speak(cur_op.wins)
			yield(Talking, "completed_typing")
		LOSER:
			Talking.speak(cur_op.loses)
			yield(Talking, "completed_typing")
		_:
			print("You actual fucking moron. The code is broken. "+
			"It's probably more my fault than yours but fuck you.")
	
	flip_ui()
	yield(Talking, "flipped")
	emit_signal("speaking_fin")

# swap between text and game controls
func flip_ui():
	PlayerHealth.toggle_on_screen()
	OpHealth.toggle_on_screen()
	MoveSelect.toggle_on_screen()
	
	Talking.toggle_on_screen()	

# handle signal from children to catch throws
func _handle_throw(throw_num):
	cur_throw = throw_num

# UTILITY METHODS

# makes a move for the opponent
func op_throw(op, history):
	rng.randomize()
	if op.id == 1: 
		return ROCK
	else: # random strat
		return rng.randi_range(ROCK, SCISSORS)

# checks who wins
func play_throw(p_throw, op_throw):
	if p_throw == op_throw:
		return TIE
		
	match p_throw:
		ROCK:
			if op_throw == SCISSORS:
				return WIN
		PAPER:
			if op_throw == ROCK:
				return WIN
		SCISSORS:
			if op_throw == PAPER:
				return WIN

	return LOSE

# finds the move which beats a move
func cheat_play(move):
	return (move + 1) % 3

# handles updating the history which becomes the memory of
# opponent players
func update_history(p_move, op_move, result):
	if len(round_history) > MAX_MEM:
		round_history.pop_back()	
	
	round_history.push_front([p_move, op_move, result])
