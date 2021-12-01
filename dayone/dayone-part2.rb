#!/usr/bin/env ruby

p File.readlines('./input')
      .map { |v| v.chomp.to_i }
      .each_cons(3)
      .map(&:sum)
      .each_cons(2)
      .map { |s| s[1] - s[0] > 0 ? 1 : 0 }
      .reduce(0, :+)
