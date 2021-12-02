#!/usr/bin/env ruby

# https://adventofcode.com/2021/day/2

module Sub
  class Navigator
    attr_accessor :aim, :x, :y

    def initialize
      @aim = 0
      @x = 0
      @y = 0
    end

    def course
      @course ||= File.readlines('./input').map do |value|
        NavCommand.new(*value.chomp.split(' '))
      end
    end

    def navigate
      course.each do |command|
        send(command.direction, command.magnitude)
        puts "navigating #{command.direction} by #{command.magnitude} to a new location (#{x}, #{y})"
      end
    end

    def up(magnitude)
      @aim -= magnitude
    end

    def down(magnitude)
      @aim += magnitude
    end

    def forward(magnitude)
      @x += magnitude
      @y += aim * magnitude
    end
  end

  class NavCommand
    attr_reader :direction, :magnitude

    def initialize(direction, magnitude)
      @direction = direction.to_sym
      @magnitude = magnitude.to_i
    end
  end
end

a = Sub::Navigator.new
a.navigate
p a.x * a.y
