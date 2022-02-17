extends Control

var hearts = 4 setget set_hearts
var maxHearts = 4 setget set_max_hearts

onready var heartUiFull = $HeartUIFull
onready var heartUiEmpty = $HeartUIEmpty

func set_hearts(value):
	hearts = clamp(value, 0, maxHearts)
	if heartUiFull != null:
		heartUiFull.rect_size.x = hearts * 15
	

func set_max_hearts(value):
	maxHearts = max(value, 1)
	self.hearts = min(hearts, maxHearts)
	if heartUiEmpty != null:
		heartUiEmpty.rect_size.x = maxHearts * 15

func _ready():
	self.maxHearts = PlayerStats.maxHealth
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
