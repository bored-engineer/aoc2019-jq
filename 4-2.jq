# cat 4-1.input | jq -Rf 4-1.jq

# is6Digit returns if the number is 6 digitis
def is6Digit:
	. >= 100000 and . <= 999999;

# hasValidDouble returns if the number has a double in it
def hasValidDouble:
	# Convert to a string and split on all repeated groups of numbers > 2
	tostring | [scan("(00+|11+|22+|33+|44+|55+|66+|77+|88+|99+)")[] 
	# Filter to groups of 2 only
	| select(length == 2)]  
	# If there are any matches, is valid
	| length > 0;

# noDecrease checks if any of the digits decrease from the previous
def noDecrease:
	# Convert to a string so we can get individual characters in it
	tostring as $numStr | 
		# Loop over every character except the last one
		reduce range(0; ($numStr | length) - 1) as $idx (0; 
			# Extract the char at idx and the next one
			($numStr[$idx:$idx+1] | tonumber) as $char |
			($numStr[$idx+1:$idx+2] | tonumber) as $nextChar | 
			# If it's less than the next, return -1
			if $nextChar < $char then -1 else . end
		# If it was 0, there were no decreases
		) == 0;

# Extract the start and stop inputs
split("-") | map(tonumber) as [$start, $stop]

# For every possible value (brute-force) in the range
| [range($start; $stop) 

# Filter to ones that meet the criteria
| select(is6Digit and hasValidDouble and noDecrease)]

# Get the unique number of matches
| length
