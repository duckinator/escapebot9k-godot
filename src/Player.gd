extends Area2D

# Player movement speed, in pixels/second.
export var speed = 400
# Size of the game window.
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# The player's movement vector.
	var velocity = Vector2.ZERO
	
	var UP = -1
	var DOWN = 1
	var LEFT = -1
	var RIGHT = 1
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		velocity.x += RIGHT * 0.5
		velocity.y += UP * 0.5
		self.rotation_degrees = 45
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		velocity.x += LEFT * 0.5
		velocity.y += UP * 0.5
		self.rotation_degrees = -45
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		velocity.x += RIGHT * 0.5
		velocity.y += DOWN * 0.5
		self.rotation_degrees = 135
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		velocity.x += LEFT * 0.5
		velocity.y += DOWN * 0.5
		self.rotation_degrees = -135
	elif Input.is_action_pressed("ui_right"):
		velocity.x += RIGHT
		self.rotation_degrees = 90
	elif Input.is_action_pressed("ui_left"):
		velocity.x += LEFT
		self.rotation_degrees = -90
	elif Input.is_action_pressed("ui_down"):
		velocity.y += DOWN
		self.rotation_degrees = 180
	elif Input.is_action_pressed("ui_up"):
		velocity.y += UP
		self.rotation_degrees = 0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
