extends Node

signal loading_progressed(scene: String, percentage: float)
signal loading_finished(scene: String)

@export var loading_screen_packed_scene: PackedScene

var _loading_screen: LoadingScreen
var _currently_loading: Dictionary = {}

var _current_scene: Node = null

########################################################################
# Scene Loading API

# Queue a scene load
# scene_path - string absolute path to the scene to load
# on_loading_finished - callable to be called when load is finished
# auto_change_scene - true will automatically switch to the loaded scene when ResourceLoader finishes
# show_loading_screen - SceneLoader toggle for covering attaching a loading screen to the tree while loading, 
func queue_scene_load_by_path(
	scene_path: String,
	on_loading_finished: Callable = Callable(),
	auto_change_scene: bool = true,
	show_loading_screen: bool = true, 
) -> void:
	ResourceLoader.load_threaded_request(scene_path)
	if show_loading_screen: 
		_show_loading_screen()
	
	if auto_change_scene: 
		_currently_loading[scene_path] = on_loading_finished
	else: _currently_loading[scene_path] = null
	set_process(true)


func chance_scene_by_scene_path(on_scene_change: Callable, scene_path: String) -> void:
	if _is_scene_loaded(scene_path):
		var target_scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
		var scene: Node = target_scene.instantiate()
		change_scene(on_scene_change, scene)


func change_scene_by_packed_scene(on_scene_change: Callable, packed_scene: PackedScene) -> void:
	var scene: Node = packed_scene.instantiate()
	change_scene(on_scene_change, scene)


func change_scene(on_scene_change: Callable, scene: Node) -> void:
	on_scene_change.call()
	get_tree().root.add_child(scene)
	_current_scene = scene
########################################################################

########################################################################
# Loading Screen
func _show_loading_screen() -> void:
	if not _loading_screen: _loading_screen = loading_screen_packed_scene.instantiate()
	if _loading_screen.is_inside_tree(): return
	
	get_tree().root.add_child(_loading_screen)


func _hide_loading_screen() -> void:
	if not _loading_screen: return
	if not _loading_screen.is_inside_tree(): return
	
	get_tree().root.remove_child(_loading_screen)
########################################################################

########################################################################
# Loading process
func _process(delta: float) -> void:
	if _currently_loading.is_empty():
		set_process(false)
		return
	
	for scene in _currently_loading.keys():
		_poll_loading(scene)


func _poll_loading(scene: String) -> void:
	var progress := []
	var status := ResourceLoader.load_threaded_get_status(scene, progress)
	match(status):
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: _loading_failed(scene, "THREAD_LOAD_INVALID_RESOURCE")
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED: _loading_failed(scene, "THREAD_LOAD_FAILED")
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS: _loading_in_progress(scene, progress)
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED: _loading_finished(scene)
########################################################################

########################################################################
# Loading status
func _loading_failed(scene: String, reason: String) -> void: 
	print("Can't load scene " + scene + " - status: " + reason)


func _loading_in_progress(scene: String, progress: Array) -> void: 
	print(scene + " - " + str(progress.front() * 100.0) + "%")
	loading_progressed.emit(scene, progress.front())


func _loading_finished(scene: String) -> void:
	_hide_loading_screen()
	loading_finished.emit(scene)
	if _currently_loading.keys().has(scene):
		if not _currently_loading[scene]:
			_currently_loading.erase(scene)
		else:
			chance_scene_by_scene_path(_currently_loading[scene], scene)
			_currently_loading.erase(scene)
########################################################################

########################################################################
# Helpers
func _is_scene_loaded(scene: String) -> bool: 
	return ResourceLoader.load_threaded_get_status(scene) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED
