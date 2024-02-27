extends CharacterBody2D  # Herda comportamento de um corpo 2D de personagem.
class_name Bird  # Nome da classe: Bird.

signal game_started


@export var gravity = 900.0  # Variável de gravidade, ajustável no editor.
@export var jump_force = -300  # Força de salto, ajustável no editor.
@export var rotation_speed = 2  # Velocidade de rotação, ajustável no editor.
@onready var animation_player = $AnimationPlayer  # Referência ao nó AnimationPlayer.

var max_speed = 400  # Velocidade máxima do pássaro.
var is_started = false  # Rastreia se o pássaro começou a voar.
var should_process_input = true

func _ready():
	velocity = Vector2.ZERO  # Inicializa a velocidade como zero.
	animation_player.play("idle")  # Inicia a animação "idle".

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && should_process_input:
		jump()  # Chama a função de salto.
		if !is_started:
			game_started.emit()
			animation_player.play("flap_wings")  # Inicia a animação de bater asas.
			is_started = true  # Marca que o voo começou.
	if !is_started:
		return  # Se o voo ainda não começou, sai da função.
	velocity.y += gravity * delta  # Aplica a gravidade à velocidade vertical.
	velocity.y = min(velocity.y, max_speed)  # Limita a velocidade vertical máxima.
	move_and_collide(velocity * delta)  # Move o pássaro e lida com colisões.
	rotate_bird()  # Chama a função para controlar a rotação do pássaro.

func jump():
	velocity.y = jump_force  # Aplica a força de salto na velocidade vertical.
	rotation = deg_to_rad(-30)  # Inclinação para cima ao saltar.

func rotate_bird():
	# Gira para baixo ao cair.
	if velocity.y > 0 and rad_to_deg(rotation) < 90:
		rotation += rotation_speed * deg_to_rad(1)
	# Gira para cima ao subir.
	elif velocity.y < 0 and rad_to_deg(rotation) > -30:
		rotation -= rotation_speed * deg_to_rad(1)
		
	
func kill():
	should_process_input = false
	
func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
	should_process_input = false
