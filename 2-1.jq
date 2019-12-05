# cat 2-1.input | jq -sRf 2-1.jq

# evaluate_opcode takes an opcode and performs the action returning the result
def evaluate_opcode($op; $arg1; $arg2):
	# 1 is add
	if $op == 1 then
		[$arg1 + $arg2, true]
	# 2 is multiply
	elif $op == 2 then
		[$arg1 * $arg2, true]
	# 99 is halt, return empty instead of a value
	elif $op == 99 then
		[-1, false]
	# Unknown opcode, return -1 
	else
		[-1, false]
	end;

# Read in the input data as numbers into an array
split(",") | map(tonumber)

# Modify the first two values per the doc
| .[1] = 12
| .[2] = 2

# We will "reduce" (modify) the program iteratively
| reduce range(0; length; 4) as $idx (.;
	# Extract the op, destination and args
	.[$idx] as $op |
	.[.[$idx + 1]] as $arg1 |
	.[.[$idx + 2]] as $arg2 |
	.[$idx + 3] as $destIdx |
	# Get the result
	evaluate_opcode($op; $arg1; $arg2) as [$result, $continue] |
	if $continue then 
		# Set the destination index as the result
		.[$destIdx] = $result
	else 
		# Print the value of the 0th element and halt
		.[0] | debug | halt
	end
)
