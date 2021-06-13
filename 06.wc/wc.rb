#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  file_names = ARGV
  file_datas = []

  if ARGV[0].nil? # 標準入力から受け取る際の処理
    stdin_value = $stdin.read
    options['l'] ? stdin_option_l(stdin_value, file_datas) : stdin_no_option(stdin_value, file_datas)
  else
    options['l'] ? option_l(file_names, file_datas) : no_option(file_names, file_datas)
  end
  puts file_datas
end

def option_l(file_names, file_datas)
  total_row = 0
  file_names.each do |f|
    io_file = File.open(f).read
    row_count = io_file.count("\n")
    total_row += row_count if file_names.size > 1
    file_datas << "#{row_count.to_s.rjust(8)} #{f}"
  end
  file_datas << "#{total_row.to_s.rjust(8)} total" if file_names.size > 1
end

def no_option(file_names, file_datas)
  total_row = 0
  total_word = 0
  total_bite = 0
  file_names.each do |f|
    io_file = File.open(f).read
    row_count = io_file.count("\n")
    word_count = io_file.split(/\s+/).count
    bite_count = io_file.bytesize
    if file_names.size > 1
      total_row += row_count
      total_word += word_count
      total_bite += bite_count
    end
    file_datas << "#{row_count.to_s.rjust(8)}#{word_count.to_s.rjust(8)}#{bite_count.to_s.rjust(8)} #{f}"
  end
  file_datas << "#{total_row.to_s.rjust(8)}#{total_word.to_s.rjust(8)}#{total_bite.to_s.rjust(8)} total" if file_names.size > 1
end

def stdin_no_option(stdin_value, file_datas)
  row_count = stdin_value.count("\n")
  word_count = stdin_value.split(/\s+/).count
  bite_count = stdin_value.bytesize
  file_datas << "#{row_count.to_s.rjust(8)}#{word_count.to_s.rjust(8)}#{bite_count.to_s.rjust(8)}"
end

def stdin_option_l(stdin_value, file_datas)
  row_count = stdin_value.count("\n")
  file_datas << row_count.to_s.rjust(8)
end

options = ARGV.getopts('l')
main(options)
