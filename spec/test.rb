trans_pattern = { :first => Proc.new { |arg| arg + 1 }, :second => Proc.new { |arg| arg + 2 } }

var = [ {:first => 10, :second => 5 } ]

trans_pattern.each { |key,value| trans_pattern[key] = value.call(var) }

p trans_pattern
