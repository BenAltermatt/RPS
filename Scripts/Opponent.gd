class_name Opponent

const MAX_MEM = 100 # you can remember the previous 100 throws

var name = -1
var id = -1
var panic = -1
var focus = -1
var memory = -1
var anim_path = "None"
var health = -1
var intros = []
var mids = []
var wins = []
var loses = []
var cur_health = -1
var p_win_path = "None"
var p_lose_path = "None"

func _init(block=null):
	var start = block.find("(")
	var end = block.find(")")
	var args = block.substr(start + 1, end - start - 1).split(",")
	
	name = args[0].strip_edges()
	id = int(args[1].strip_edges())
	panic = int(args[2].strip_edges())
	focus = int(args[3].strip_edges())
	memory = int(args[4].strip_edges())
	health = int(args[5].strip_edges())
	cur_health = health
	anim_path = args[6].strip_edges()
	p_win_path = args[7].strip_edges()
	p_lose_path = args[8].strip_edges()
	
	var lines = block.split("\n")
	
	# every new line
	for line in range(1, len(lines)):
		args = lines[line].split(":")
		
		if args[0].strip_edges() == "intro":
			intros.append(args[1].strip_edges())
		elif args[0].strip_edges() == "mid":
			mids.append(args[1].strip_edges())
		elif args[0].strip_edges() == "win":
			wins.append(args[1].strip_edges())
		elif args[0].strip_edges() == "lose":
			loses.append(args[1].strip_edges())

func print_opponent():
	print("(%s, %d, %d, %d, %d, %d, %s)" % [name, id, panic, focus, memory, health, anim_path])
	for intro in intros:
		print("- intro : %s" % intro)
	for mid in mids:
		print("- mid : %s" % mid)
	for win in wins: 
		print("- win : %s" % win)
	for lose in loses:
		print("- lose : %s" % lose)


