extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 100
const MAX_SPEED = 350
const JUMP_HEIGHT = -600
const POST_JUMP_BOOST = 225
var JUMP_TIMER = 0
var JUMPS_LEFT = 0
const FALL_SPD = 200
var MOVING_RIGHT = true
var CAN_NORMAL_JUMP = false
var COYOTE_TIMER = 0
var motion = Vector2()

func _physics_process(delta):
	motion.y += GRAVITY
	var friction = false
	
	

	if is_on_floor():
		JUMPS_LEFT = 2
		CAN_NORMAL_JUMP = true
		COYOTE_TIMER = 0
	
	if not is_on_floor():
		COYOTE_TIMER += delta
		
	if (COYOTE_TIMER <= 0.25):
		CAN_NORMAL_JUMP = true
	else:
		CAN_NORMAL_JUMP = false
	
	
	if is_on_wall() and not $Sprite.flip_h:
		if  Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
			motion.y = JUMP_HEIGHT
			
	if is_on_wall() and ($Sprite.flip_h):
		if  Input.is_action_pressed("ui_right"):
			motion.y = JUMP_HEIGHT
			
	
	if $Sprite.flip_h == true:
		if is_on_wall() and ($Sprite.flip_h):
			if  Input.is_action_pressed("ui_right"):
				motion.y = JUMP_HEIGHT
		if Input.is_action_pressed("ui_left"):
			MOVING_RIGHT = false
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		MOVING_RIGHT = false
		motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
	else:
		friction = true
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
			JUMP_TIMER += delta
			JUMPS_LEFT = 1
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	if (not is_on_floor()) and (Input.is_action_just_pressed("ui_up")):
		if (JUMPS_LEFT > 0):
				motion.y = 3*JUMP_HEIGHT/4
				JUMP_TIMER -= 1
				JUMPS_LEFT = 0;
	
	if (JUMP_TIMER > 1):
		motion.y = JUMP_HEIGHT
		JUMP_TIMER = 0
		
		
	motion = move_and_slide(motion, UP)
	pass