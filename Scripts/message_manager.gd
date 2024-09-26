extends Node

signal show_message(message_text)

var message_visible : bool = false
var message_text : String

func display_message(text : String):
	show_message.emit(text)
