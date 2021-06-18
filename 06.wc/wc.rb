#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  if ARGV[0].nil? # 標準入力から受け取る際の処理
    stdin_value = $stdin.read
    options['l'] ? output_stdin_option_l(stdin_value) : output_stdin_no_option(stdin_value)
  else
    file_names = ARGV
    options['l'] ? output_option_l(file_names) : output_no_option(file_names)
  end
end

def output_option_l(file_names)
  total_row = 0
  file_names.each do |file_name|
    file_content = File.open(file_name) { |file| file.read }
    row_count = file_content.count("\n")
    total_row += row_count if file_names.size > 1
    puts "#{row_count.to_s.rjust(8)} #{file_name}"
  end
  puts "#{total_row.to_s.rjust(8)} total" if file_names.size > 1
end

def output_no_option(file_names)
  total_row = 0
  total_word = 0
  total_byte = 0
  file_names.each do |file_name|
    file_content = File.open(file_name) { |file| file.read }
    row_count = file_content.count("\n")
    word_count = file_content.split(/\s+/).count
    byte_count = file_content.bytesize
    if file_names.size > 1
      total_row += row_count
      total_word += word_count
      total_byte += byte_count
    end
    puts "#{[row_count, word_count, byte_count].map { |value| value.to_s.rjust(8) }.join} #{file_name}"
  end
  puts "#{[total_row, total_word, total_byte].map { |value| value.to_s.rjust(8) }.join} total" if file_names.size > 1
end

def output_stdin_no_option(stdin_value)
  row_count = stdin_value.count("\n")
  word_count = stdin_value.split(/\s+/).count
  byte_count = stdin_value.bytesize
  puts [row_count, word_count, byte_count].map { |value| value.to_s.rjust(8) }.join
end

def output_stdin_option_l(stdin_value)
  row_count = stdin_value.count("\n")
  puts row_count.to_s.rjust(8)
end

options = ARGV.getopts('l')
main(options)
