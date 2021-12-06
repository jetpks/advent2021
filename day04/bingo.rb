#!/usr/bin/env ruby

require 'forwardable'

module Sub
  module Bingo
    class Game
      attr_reader :boards

      def initialize
        @boards = []
        @call_index = 0
        Parser.new.tap do |parser|
          @calls = parser.calls
          parser.rows.each_slice(parser.rows.first.length) do |row_bundle|
            @boards << Board.new(row_bundle)
          end
        end
      end

      def play
        number = call
        boards.each { |b| b.mark(number) }
      end

      def winning_boards
        boards.select(&:winner?)
      end

      private

      attr_reader :calls

      def call
        @calls[@call_index].tap { @call_index += 1 }
      end
    end

    class Board
      attr_reader :rows, :columns, :winning_call

      def initialize(raw_rows)
        @winning_call = nil
        @rows = raw_rows.map { |r| Row.new(r) }
        @columns = []
        rows.length.times do |i|
          @columns << Column.new(rows.map { |r| r[i] })
        end
      end

      def mark(number)
        rows.each { |r| r.mark(number) }
        columns.each { |c| c.mark(number) }
        @winning_call = number if winner?
      end

      def score
        return 0 unless winner?

        rows.map { |r| r.unmarked_numbers.sum }.sum * @winning_call
      end

      def winner?
        rows.any?(&:winner?) || columns.any?(&:winner?)
      end
    end

    class Row
      attr_reader :numbers, :marked

      extend Forwardable
      def_delegators :@numbers, :[], :include?

      def initialize(numbers)
        @numbers = numbers
        @marked = Array.new(numbers.length, false)
      end

      def mark(number)
        index = @numbers.index(number)
        return false if index.nil?

        @marked[index] = true
      end

      def unmarked_numbers
        [].tap do |chosen|
          @marked.each_with_index do |is_marked, index|
            chosen << numbers[index] unless is_marked
          end
        end
      end

      def winner?
        @marked.all?
      end
    end

    class Column < Row; end

    class Parser
      attr_reader :calls, :rows

      def initialize(path: 'input')
        @rows = []
        File.readlines(path).each do |line|
          line.chomp!
          next if line.match?(/^$/)

          # detect ','; that line contains the calls
          if line.include?(',')
            @calls = line.split(',').map(&:to_i)
            next
          end

          @rows << line.split.map(&:to_i)
        end
      end
    end
  end
end
