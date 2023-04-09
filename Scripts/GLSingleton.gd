extends Node

var Opponent = load("res://Scripts/Opponent.gd")


var cur_op_ind #the current index of the opponent we are on
var ops
var won 

func _ready():
    won = false
    ops = read_in_opps()
    cur_op_ind = 0


# reads in opponent informtation from a file
func read_in_opps():
    var ret_ops = []

    var file = File.new()
    file.open("res://Assets/Files/Opponents.txt", File.READ)
    var blocks = file.get_as_text().split(";")
    for block in blocks:
        if(len(block.strip_edges()) > 0):
            ret_ops.append(Opponent.new(block.strip_edges())) 

    return ret_ops

func next_enemy(win):
    won = win
    get_tree().change_scene("res://Scenes/WinLose.tscn")