extends Node

enum GameState {IDLE, RUNNING, ENDED}

var game_state
@onready var bird = $"../Bird"
@onready var pipe_spawner = $"../PipeSpawner"
@onready var ground = $"../Ground"
@onready var ui = $"../UI"



var points = 0

func _ready():
	bird.game_started.connect(on_game_started)
	pipe_spawner.bird_crashed.connect(end_game)
	ground.bird_crashed.connect(end_game)
	pipe_spawner.point_scored.connect(on_point_scored)

func on_game_started():
	pipe_spawner.start_spawning_pipes()
	
func end_game():
	bird.kill()
	pipe_spawner.stop();
	ground.stop();
	ui.on_game_over()

func on_point_scored():
	points += 1
	ui.update_points(points)
