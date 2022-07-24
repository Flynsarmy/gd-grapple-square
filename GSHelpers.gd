extends Node

# Adapted from https://www.reddit.com/r/godot/comments/4nllfn/comment/d44zqjq/
func format_number(num: int) -> String:
	var num_str: String = str(num)
	var str_length: int = num_str.length()
	var s: String
	
	if str_length < 4:
		return num_str
	
	for i in range(str_length):
			if((str_length - i) % 3 == 0 and i > 0):
				s = str(s, ",", num_str[i])
			else:
				s = str(s, num_str[i])
			
	return s
