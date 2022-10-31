extends Object

func _ready():
	# if OS.get_name() != "HTML5":
	var connect_retort = connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
	if connect_retort != OK:
		print("Failed to connect `meta_clicked`, error code ", connect_retort)


func _on_RichTextLabel_meta_clicked(meta):
	var shell_open_retort = OS.shell_open(meta)
	if shell_open_retort != OK:
		print("Failed to open shell to view link, error code ", shell_open_retort)
