# cat 1-2.input | jq -sf 1-2.jq

# Define a function we can call recursively
def fuel_required:
	# Same calulation as 1-1
	(. / 3 | floor - 2) |
	# If it became negative, return 0
	if . < 0 then 
		0
	else
		. + (. | fuel_required)
	end;

# For every input module, run the calculation and add the result
map(fuel_required) | add
