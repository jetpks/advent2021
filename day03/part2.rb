#!/usr/bin/env ruby

module Sub
  class BinaryDiagnostic
    def each_row
      File.open('./input') do |f|
        f.each_line { |l| yield l.chomp }
      end
    end

    def columnar_summary
      @columnar_summary ||= [].tap do |summary|
        each_row do |row|
          row.chars.each_with_index do |value, idx|
            summary[idx] = [0, 0] if summary[idx].nil?
            summary[idx][value.to_i] += 1
          end
        end
      end
    end

    def gamma_rate
      @gamma_rate ||= columnar_summary
                      .map { |col| col.index(col.max) }
                      .join
                      .to_i(2)
    end

    def epsilon_rate
      @epsilon_rate ||= columnar_summary
                        .map { |col| col.index(col.min) }
                        .join
                        .to_i(2)
    end
  end
end

p Sub::BinaryDiagnostic.new.gamma_rate * Sub::BinaryDiagnostic.new.epsilon_rate
