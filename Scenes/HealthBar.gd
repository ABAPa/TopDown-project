extends TextureProgressBar
@export var healthHandler : HealthHandler

func _ready():
	healthHandler.healthChanged.connect(update_health_bar)
	update_health_bar()

func update_health_bar():
	value = healthHandler.current_health * 100 / healthHandler.max_health

