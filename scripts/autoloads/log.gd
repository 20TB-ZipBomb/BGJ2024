extends Object

## Simple helper class for logs. Mostly used for the pretty colors.
##
## Because GDScript doesn't permit `vararg` these have to accept a single pre-formatted string as an argument.
## Example usage:
## 	Log.debug("This is a debug message")
## 	Log.warn("This is a %s message" % "warn")
## 	Log.error("This is an %s message, it is the %drd message in this example list", ["error", 3])
class_name Log


## Logs a formatted debug message to the console.
static func debug(msg: String) -> void:
	print_rich("[color=white][b][log][/b][/color] ", msg)


## Logs a formatted info message to the console.
static func info(msg: String) -> void:
	print_rich("[color=orange][b][info][/b] ", msg, "[/color]")


## Logs a formatted warning message to the console.
static func warn(msg: String) -> void:
	print_rich("[color=yellow][b][warn][/b] ", msg)


## Logs a formatted error message to the console and dumps all frames in the current callstack.
static func error(msg: String, show_callstack: bool = true) -> void:
	print_rich("[color=red][b][error][/b] ", msg, "[/color]")
	if show_callstack:
		print_rich("[color=red][i]Callstack:[/i]")
		for frame in get_stack():
			print_rich("\t[color=red][i]", frame["source"], ":", frame["line"], " in function ", frame["function"], "[/i]")
