extends Node

signal finished_round

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

var Opponent = load("res://Scripts/Opponent.gd")
var MoveSelect
var PlayerHealth
var OpHealth
var Talking
var rng = RandomNumberGenerator.new()

var opps = []
var round_history = []
var thrown = false
var cur_throw = -1
var middle_of_round = false
var middle_of_match = false

var p_health = PLAYER_HEALTH


func _ready():
	read_in_opps()
	
	Talking = $Talking
	
	MoveSelect = $MoveSelect
	var temp = get_node("MoveSelect/TextureRect/Control").get_children()
	for child in temp:
		child.connect("throw_clicked", self, "_handle_throw")
	
	PlayerHealth = get_node("PlayerHealth")
	OpHealth = get_node("OpHealth")
	
	PlayerHealth.update_health(3, 3)
	
	say(opps[0], WIN)
	
	game_loop()
	

	
func game_loop():
	for cur_op in opps:
		if middle_of_match:
			yield(self, "finished_round")
		full_match(cur_op)

		

func full_match(cur_op):
	middle_of_match = true
	# animate enemy entry 
	
	PlayerHealth.update_health(PLAYER_HEALTH, p_health)
	OpHealth.update_health(cur_op.health, cur_op.cur_health)
	
	# intro
	
	while cur_op.cur_health > 0 and p_health > 0:
		if not middle_of_round:
			play_round(cur_op)
		yield(get_tree().create_timer(1), "timeout")
		
	
	if cur_op.cur_health > 0: # we lost
		# game over
		# op say win
		pass
	else: # we won
		# op say lose
		# animate enemy exit
		pass
	middle_of_match = false
	
func read_in_opps():
	var file = File.new()
	file.open("res://Assets/Files/Opponents.txt", File.READ)
	var blocks = file.get_as_text().split(";")
	for block in blocks:
		if(len(block.strip_edges()) > 0):
			opps.append(Opponent.new(block.strip_edges())) 

# returns a move for the player, this is where the AI will be implemented
func op_throw(op, history):
	rng.randomize()
	if op.id == 1: 
		return rng.randi_range(ROCK, SCISSORS)
	else: # random strat
		return rng.randi_range(ROCK, SCISSORS)
		

func play_throw(p_throw, op_throw):
	if p_throw == op_throw:
		return TIE
		
	if p_throw == ROCK:
		if op_throw == SCISSORS:
			return WIN
		return LOSE
		
	if p_throw == PAPER:
		if op_throw == SCISSORS:
			return LOSE
		return WIN
		
	if p_throw == SCISSORS:
		if op_throw == ROCK:
			return LOSE
		return WIN

func play_round(cur_op):
	middle_of_round = true
	var caught = false # were you caught cheating?
	# display ready 
	
	# do count down / throw
	cur_throw = -1
	print("ROCK")# display rock
	yield(get_tree().create_timer(1), "timeout")
	print("PAPER")# display paper
	yield(get_tree().create_timer(1), "timeout")
	print("SCISSORS")#display scissors
	yield(get_tree().create_timer(1), "timeout")
	print("SHOOT")# display shoot
	yield(get_tree().create_timer(.1), "timeout")
	
	# now we will verify that you have shot
	if cur_throw == -1:
		caught = true
		
	# if not caught, and we tried to cheat, lets do the cheat logic
	if cur_throw == 3:
		# when focus is higher, the probability of success is lower
		var prob = cur_op.focus * (MIN_CHEAT - MAX_CHEAT) / (MAX_FOCUS - MIN_FOCUS) + MIN_CHEAT
		
		caught = prob > rng.randf()
		
	var op_choice = op_throw(cur_op, round_history)
	var result = -1
	
	if caught:
		result = DQ
		say(cur_op, MID) # they call you out on your cheating
	else: 
		result = play_throw(cur_throw, op_choice)
		
	if result == DQ:
		p_health -= CHEAT_PENALTY
	if result == WIN:
		cur_op.cur_health -= LOSS_PENALTY
	if result == LOSE:
		p_health -= LOSS_PENALTY
		
	PlayerHealth.update_health(PLAYER_HEALTH, max(p_health, 0))
	OpHealth.update_health(cur_op.health, max(cur_op.cur_health, 0))
	
	update_history(cur_throw, op_choice, result)

	# say mid words
	middle_of_round = false
	emit_signal("finished_round")

	
func update_history(p_move, op_move, result):
	if len(round_history) > MAX_MEM:
		round_history.pop_back()	
	
	round_history.push_front([p_move, op_move, result])

func flip_ui():
	PlayerHealth.toggle_on_screen()
	OpHealth.toggle_on_screen()
	MoveSelect.toggle_on_screen()
	
	Talking.toggle_on_screen()

func say(cur_op, context):
	var waiting
	
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
