# cat 2-2.input | jq -sRf 2-2.jq

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

# evaluate a full array of values
def evaluate:
	# TODO: We're just assuming it ends in 99 
	reduce range(0; length - 1; 4) as $idx (.;
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
			# Return the value of the 0th element
			.[0]
		end
	);

# Read in the input data as numbers into an array
split(",") | map(tonumber) as $prog |

# Brute force every possible noun and verb :fine:
range(0;99) | . as $noun |
range(0;99) | . as $verb |

# Modify the program and evaluate it
$prog | .[1] = $noun | .[2] = $verb | evaluate |

# Find the target value, calculate the result
select(. == 19690720) | 100 * $noun + $verb
