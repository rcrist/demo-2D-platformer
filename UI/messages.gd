extends Control

func _ready():
	MessageManager.connect("show_message", _on_show_message)

func _on_button_pressed() -> void:
	self.visible = false

func _on_show_message(text : String) -> void:
	print("On show message called")
	self.visible = true
	$RichTextLabel.text = text
