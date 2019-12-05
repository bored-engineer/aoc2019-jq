# cat 3-2.input | jq -sRf 3-2.jq

# trace takes an action starting at (x,y) and emits an array of every point on it
def trace($steps; $x; $y):
	# Extract the direction and number from input
	.[0:1] as $dir |
	(.[1:] | tonumber + 1) as $num |
	# Generate every value in $num
	[range(1; $num; 1) | 
		# Switch direction for each
		if $dir == "R" then
			{loc: [$x + ., $y], steps: ($steps + .)}
		elif $dir == "L" then
			{loc: [$x - ., $y], steps: ($steps + .)}
		elif $dir == "U" then
			{loc: [$x, $y + .], steps: ($steps + .)}
		elif $dir == "D" then
			{loc: [$x, $y - .], steps: ($steps + .)}
		else empty end];

# points gets all points given a set of instructions starting at (0,0)
def points:
	# For each instruction, expand our set of 
	reduce .[] as $inst ([]; 
		# Extract the current cursor, failing back to (0,0) if not specified
		(last | .loc // [0,0]) as [$x, $y] |
		# Get the number of steps
		length as $size | 
		# Append to the running array after processing the instruction 
		. + ($inst | trace($size; $x; $y))
	);


# Split by each line and then by each directive in the line
split("\n") | map(split(","))

# Convert to a list of points and remove duplicates within each wire
| map(points | unique_by(.loc))

# Combine all the wires
| add

# Group by points and select any with more than 1 wire using the point
| group_by(.loc) | map(select(length > 1))

# Calculate the number of steps for each
| map(map(.steps) | add) 

# Sort it and get the lowest steps as the result
| sort | first
