extends Node

signal line_started(id: String)
signal line_finished(id: String)
signal narrator_interrupted(id: String)

## Emitted whenever a line's text should be shown. `speaker` is "narrator"
## or "true_narrator" 
signal subtitle_requested(text: String, speaker: String)
signal subtitle_cleared(speaker: String)

##instead of a JSON file with a lot of text, do it the simpler yet more boring way
##scripting each event individually

##follow format of "id": {"text": "...", "audio": "res://..."}
const LINES: Dictionary = {
	# ---------------- Menu: broken START button ----------------
	"menu_start_fail_1": {
		"text": "Well, that's odd. Try again for me.",
		"audio": "res://audio/narrator/menu_start_fail_1.ogg",
	},
	"menu_start_fail_2": {
		"text": "Welp! Looks like the game is bugged. Guess the developers did a poor job. Who programmed this? Blame them; I didn't do anything.",
		"audio": "res://audio/narrator/menu_start_fail_2.ogg",
	},
	"menu_credits_look": {
		"text": "Look at the names of all these idiots. Jay… what type of name is that? These letters don't even seem that put together.",
		"audio": "res://audio/narrator/menu_credits_look.ogg",
	},
	"menu_blocks_monkey": {
		"text": "You look like a monkey playing with these blocks.",
		"audio": "res://audio/narrator/menu_blocks_monkey.ogg",
	},
	"menu_time_out_leave": {
		"text": "There's no way to START the game. You can leave now, and I can finally go on break.",
		"audio": "res://audio/narrator/menu_time_out_leave.ogg",
	},
	"menu_letters_wrong_1": {
		"text": "What the? Those letters aren't supposed to be there!",
		"audio": "res://audio/narrator/menu_letters_wrong_1.ogg",
	},
	"menu_letters_wrong_2": {
		"text": "Stop it now! You're going to break the game!",
		"audio": "res://audio/narrator/menu_letters_wrong_2.ogg",
	},
	"menu_spell_correct": {
		"text": "Huh. I guess I was wrong. Carry on then.",
		"audio": "res://audio/narrator/menu_spell_correct.ogg",
	},
	# ---------------- Room 1: reversed controls ----------------
	"room1_welcome": {
		"text": "Welcome to the game I guess. Uhhh, get to the other side. W, A, S, D. C'mon, you play games, right? Chop chop!",
		"audio": "res://audio/narrator/room1_welcome.ogg",
	},
	"room1_reversed_controls": {
		"text": "Dear god, I have you on a leash! Haha! Just try to move forward as usual, idiot.",
		"audio": "res://audio/narrator/room1_reversed_controls.ogg",
	},
	"room1_pickup_object": {
		"text": "You can't do that! You are just meant to move! Who gave you pointer power?",
		"audio": "res://audio/narrator/room1_pickup_object.ogg",
	},
	"room1_dont_press_1": {
		"text": "Don't press that.",
		"audio": "res://audio/narrator/room1_dont_press_1.ogg",
	},
	"room1_dont_press_2": {
		"text": "…",
		"audio": "res://audio/narrator/room1_dont_press_2.ogg",
	},
	"room1_dont_press_3": {
		"text": "You pressed it.",
		"audio": "res://audio/narrator/room1_dont_press_3.ogg",
	},
	"room1_softlock_bluff": {
		"text": "I don't exactly like where this is going. Just turn around now. Will ya? This room is impossible. Yep, nothing you can do. You are softlocked. There.",
		"audio": "res://audio/narrator/room1_softlock_bluff.ogg",
	},
 
	# ---------------- Room 2: brightness puzzle ----------------
	"room2_dark_intro_1": {
		"text": "Ugh, it's dark in here. Budget cuts. Take it up with Jay.",
		"audio": "res://audio/narrator/room2_dark_intro_1.ogg",
	},
	"room2_dark_intro_2": {
		"text": "There's a door somewhere. Probably. Feel around with your face.",
		"audio": "res://audio/narrator/room2_dark_intro_2.ogg",
	},
	"room2_stuck_hint_1": {
		"text": "The brightness is fine. That's an artistic choice. It's called 'mood'.",
		"audio": "res://audio/narrator/room2_stuck_hint_1.ogg",
	},
	"room2_stuck_hint_2": {
		"text": "Stop squinting at the corner of the screen. There's nothing there.",
		"audio": "res://audio/narrator/room2_stuck_hint_2.ogg",
	},
	"room2_grab_slider_1": {
		"text": "WHAT ARE YOU DOING?",
		"audio": "res://audio/narrator/room2_grab_slider_1.ogg",
	},
	"room2_grab_slider_2": {
		"text": "That is not a platform! That is a SETTING! There's a difference and I shouldn't have to explain it!",
		"audio": "res://audio/narrator/room2_grab_slider_2.ogg",
	},
	"room2_standing_on_ui": {
		"text": "You're standing on the user interface. I want that on record. I want that written down somewhere.",
		"audio": "res://audio/narrator/room2_standing_on_ui.ogg",
	},
	"room2_door_visible": {
		"text": "Oh, that door? That was always there. I wasn't hiding it. Why would I hide a door?",
		"audio": "res://audio/narrator/room2_door_visible.ogg",
	},
	"room2_bar_left_behind": {
		"text": "Ha! Left your little toy behind, did you? Tough. Sliders are non-transferable. It's in the terms of service.",
		"audio": "res://audio/narrator/room2_bar_left_behind.ogg",
	},
	"room2_poke_through_wall_1": {
		"text": "Wha-? You are in the NEXT LEVEL. That's TWO SEPARATE ROOMS!",
		"audio": "res://audio/narrator/room2_poke_through_wall_1.ogg",
	},
	"room2_poke_through_wall_2": {
		"text": "The wall is there for a REASON, the reason is that I put it there!",
		"audio": "res://audio/narrator/room2_poke_through_wall_2.ogg",
	},
	"room2_solved": {
		"text": "I'm noting your name down. I hope you know that. There's a list.",
		"audio": "res://audio/narrator/room2_solved.ogg",
	},
 
	# ---------------- Room 4: volume puzzle (Gary is asleep) ----------------
	"room4_intro_1": {
		"text": "Oh, don't mind him. That's Gary. He's on break. Must be nice, right? Wouldn't know.",
		"audio": "res://audio/narrator/room4_intro_1.ogg",
	},
	"room4_intro_2": {
		"text": "There's a key on that desk. Wake him up and he'll take it back, so, y'know. Tiptoe. Do a little tiptoe.",
		"audio": "res://audio/narrator/room4_intro_2.ogg",
	},
}

const TRUE_LINES: Dictionary = {
	"narrator_reveal_1": {
		"text": "Hey... HEY! Stop fiddling that bar real quick. 
		It's me, the REAL narrator",
		"audio": "res://audio/narrator/true_reveal_1.ogg",
	},
}
var is_speaking: bool = false
var is_true_speaking: bool = false

var _queue: Array[String] = []
var _current_id: String = ""
var _gap_timer: float = 0.0
var _gap_target: float = 0.0

@onready var _player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var _true_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	_player.bus = "Narrator"
	_player.finished.connect(_on_line_audio_finished)
	add_child(_player)

	_true_player.bus = "TrueNarrator"
	add_child(_true_player)

func _process(delta: float) -> void:
	if _gap_timer > 0.0:
		_gap_timer -= delta
		if _gap_timer <= 0.0:
			_advance_queue()

#Normal Narrator, calls these functions anywhere for a one shot

## Interrupts anything playing and says this line immediately.
func say(id: String) -> void:
	_queue.clear()
	_play_line(id)

## Queues one or more lines to play in order after the current one finishes.
func queue_lines(ids: Array[String], gap: float = 0.3) -> void:
	_gap_target = gap
	_queue.append_array(ids)
	if not is_speaking:
		_advance_queue()

## Immediately cuts off the current line (audio + subtitle), e.g. when the
## player mutes the narrator bus mid-sentence.
func interrupt() -> void:
	if not is_speaking:
		return
	var id := _current_id
	_player.stop()
	subtitle_cleared.emit("narrator")
	is_speaking = false
	_current_id = ""
	_queue.clear()
	narrator_interrupted.emit(id)

# Hidden true narrator, calls these functions anywhere for a one shot

func say_true(id: String) -> void:
	var data: Dictionary = TRUE_LINES.get(id, {})
	if data.is_empty():
		push_warning("Narrator: unknown true-line id '%s'" % id)
		return

	is_true_speaking = true
	subtitle_requested.emit(data.get("text", ""), "true_narrator")

	var audio_path: String = data.get("audio", "")
	if audio_path != "" and ResourceLoader.exists(audio_path):
		_true_player.stream = load(audio_path)
		_true_player.play()
		await _true_player.finished
	else:
		# No audio yet — fall back to subtitle-only, held briefly.
		await get_tree().create_timer(2.0).timeout

	subtitle_cleared.emit("true_narrator")
	is_true_speaking = false

# ---------------- Internal ----------------

func _advance_queue() -> void:
	if _queue.is_empty():
		return
	var next_id: String = _queue.pop_front()
	_play_line(next_id)

func _play_line(id: String) -> void:
	var data: Dictionary = LINES.get(id, {})
	if data.is_empty():
		push_warning("Narrator: unknown line id '%s'" % id)
		return

	_current_id = id
	is_speaking = true
	subtitle_requested.emit(data.get("text", ""), "narrator")
	line_started.emit(id)

	var audio_path: String = data.get("audio", "")
	if audio_path != "" and ResourceLoader.exists(audio_path):
		_player.stream = load(audio_path)
		_player.play()
	else:
		# No audio file yet: hold the subtitle for a readable duration,
		# then treat it as finished so queues/puzzles keep working.
		var hold_time: float = max(1.5, data.get("text", "").length() * 0.05)
		await get_tree().create_timer(hold_time).timeout
		_on_line_audio_finished()

func _on_line_audio_finished() -> void:
	if not is_speaking:
		return # already interrupted
	var finished_id := _current_id
	is_speaking = false
	_current_id = ""
	subtitle_cleared.emit("narrator")
	line_finished.emit(finished_id)

	if not _queue.is_empty():
		_gap_timer = _gap_target
	# else: stay idle until say() or queue_lines() is called again
