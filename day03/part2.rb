#!/usr/bin/env ruby

module Sub
  class BinaryDiagnostic
    def full_rows
      @full_rows ||= [].tap do |r|
        File.open('./input') do |f|
          f.each_line { |l| r << l.chomp }
        end
      end
    end

    def columnar_summary(rows: full_rows)
      [].tap do |summary|
        rows.each do |row|
          row.chars.each_with_index do |value, idx|
            summary[idx] = [0, 0] if summary[idx].nil?
            summary[idx][value.to_i] += 1
          end
        end
      end
    end

    def oxygen_generator_rating(working_rows: full_rows, index: 0)
      summary = columnar_summary(rows: working_rows)[index]

      majority_for_index = summary.first == summary.last ? '1' : summary.index(summary.max).to_s

      filtered_rows = working_rows.select do |r|
        r[index] == majority_for_index
      end

      if filtered_rows.size == 1
        filtered_rows.first.to_i(2)
      else
        oxygen_generator_rating(working_rows: filtered_rows, index: index + 1)
      end
    end

    def co2_scrubber_rating(working_rows: full_rows, index: 0)
      summary = columnar_summary(rows: working_rows)[index]

      minority_for_index = summary.first == summary.last ? '0' : summary.index(summary.min).to_s

      filtered_rows = working_rows.select do |r|
        r[index] == minority_for_index
      end

      if filtered_rows.size == 1
        filtered_rows.first.to_i(2)
      else
        co2_scrubber_rating(working_rows: filtered_rows, index: index + 1)
      end
    end

    def life_support_rating
      oxygen_generator_rating * co2_scrubber_rating
    end
  end
end

p Sub::BinaryDiagnostic.new.life_support_rating
