# cat 3-1.input | jq -sRf 3-1.jq

# trace takes an action starting at (x,y) and emits an array of every point on it
def trace($x; $y):
	# Extract the number from input
	(.[1:] | tonumber) as $num |
	# Build the slice of values for each
	if startswith("R") then
		[range($x + 1; $x + $num + 1; 1) | [., $y]]
	elif startswith("L") then
		[range($x - 1; $x - $num - 1; -1) | [., $y]]
	elif startswith("U") then
		[range($y + 1; $y + $num + 1; 1) | [$x, .]]
	elif startswith("D") then
		[range($y - 1; $y - $num - 1; -1) | [$x, .]]
	# Unknown, no new points
	else 
		[]
	end;

# points gets all points given a set of instructions starting at (0,0)
def points:
	# For each instruction, expand our set of 
	reduce .[] as $inst ([]; 
		# Extract the current cursor, failing back to (0,0) if not specified
		(last // [0, 0]) as [$x, $y] | 
		# Append to the running array after processing the instruction 
		. + ($inst | trace($x; $y))
	);


# Split by each line and then by each directive in the line
split("\n") | map(split(","))

# Convert to a list of points and remove duplicates within each wire
| map(points | unique)

# Combine all the wires
| add

# Group by points and select any with more than 1 wire using the point
| group_by(.) | map(select(length > 1))

# Convert each of the points into a taxicab distance from (0,0)
| map(.[0] as [$x, $y] | ($x | fabs) + ($y | fabs))

# Sort it and get the lowest distance as the result
| sort | first
