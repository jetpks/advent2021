#!/usr/bin/env ruby

def input
  File.readlines('./input').map { |v| v.chomp.to_i }
end

puts '// part one'
p input.each_cons(2).count { |s| s[1] > s[0] }

puts '// part two'
p input.each_cons(3)
       .map(&:sum)
       .each_cons(2)
       .count { |s| s[1] > s[0] }
