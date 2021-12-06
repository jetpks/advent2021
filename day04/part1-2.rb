#!/usr/bin/env ruby

require_relative './bingo'

module Sub
  class GiantSquid
    attr_reader :bingo

    def initialize
      @bingo = Bingo::Game.new
    end

    def part1
      bingo.play until bingo.winning_boards.length > 0

      p bingo.winning_boards.first.score
    end

    def part2
      bingo.play until bingo.winning_boards.length == bingo.boards.length - 1
      last_board = bingo.boards.select { |b| !bingo.winning_boards.include?(b) }.first
      bingo.play until last_board.winner?
      p last_board.score
    end
  end
end

giant_squid_game = Sub::GiantSquid.new
giant_squid_game.part1
giant_squid_game.part2
