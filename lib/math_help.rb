

################################################################################

def max(a, b)
	return (a > b) ? a : b
end


def min(a, b)
	return (a < b) ? a : b
end


# Squared Euclidean distance
def euclidean_dist_sq(vec1, vec2)
		raise "Array sizes are not the same" unless vec1.size == vec2.size
		dist = 0.0
		vec1.each_index { |i|
			dist += (vec1[i] - vec2[i])*(vec1[i] - vec2[i])
		}
		return dist
end


################################################################################


