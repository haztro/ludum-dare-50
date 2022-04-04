extends Node

var audio_files = \
{
	"main_build" : ["res://assets/audio/main_build.wav", "SFX", 0],
	"built" : ["res://assets/audio/built.wav", "SFX", 0],
	"built1" : ["res://assets/audio/built1.wav", "SFX", 0],
	"button_press" : ["res://assets/audio/button_press.wav", "SFX", 0],
	"saved" : ["res://assets/audio/saved.wav", "SFX", 0],
	"wave" : ["res://assets/audio/wave.wav", "SFX", 0],
	"music" : ["res://assets/audio/music.wav", "MUSIC", 1],
}

var audio_streams = {}
var audio_buses = {}
var audio_stream_players = {}
var time_last_played = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_audio() # probs change 
	play("music", -12)
		
		
func load_audio():
	for key in audio_files:
		var stream = load(audio_files[key][0])
		stream.set_loop_mode(audio_files[key][2])
		audio_streams[key] = stream 
		audio_buses[key] = audio_files[key][1]
		time_last_played[key] = 0


func play(sound_name, volume = -3, pitch = 1.0, fade = 0):
	if !audio_streams.has(sound_name):
		print("Cannot find sound %s" % sound_name)
		return
		
	var stream_player = AudioStreamPlayer.new()
	stream_player.connect("finished", self, "_on_sound_finished", [stream_player])
	stream_player.set_stream(audio_streams[sound_name])
	stream_player.set_bus(audio_buses[sound_name])
	stream_player.set_pitch_scale(pitch)
	stream_player.set_volume_db(volume)
	add_sound(stream_player)
	
	if fade != 0:
		stream_player.volume_db = -80
		var t = Tween.new()
		t.connect("tween_completed", self, "_on_fade_finished", [t])
		t.interpolate_property(stream_player, "volume_db", -80, volume, fade, Tween.TRANS_LINEAR, Tween.EASE_IN)
		add_child(t)
		t.start()
	
	stream_player.play()
	time_last_played[sound_name] = OS.get_ticks_msec()

func stop(sound_name):
	pass

func add_sound(sound):
	add_child(sound)
	
func remove_sound(sound):
	sound.queue_free()
	remove_child(sound)

func get_time_last_played(sound_name):
	return time_last_played[sound_name]

func get_num_playing(sound_name):
	var count = 0
	for s in get_children():
		if s.stream == audio_streams[sound_name]:
			count += 1
	return count

func _on_sound_finished(sound):
	remove_sound(sound)
	
func _on_fade_finished(object, path, fade):
	fade.queue_free()
	remove_child(fade)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
