#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main(option)
  directories = Dir.glob('*')
  directories.unshift(Dir.glob('.*')).flatten! if option['a']
  directories.reverse! if option['r']

  if option['l']
    option_l(directories)
  else
    arrange_without_option(directories)
  end
end

def option_l(directories)
  directories.each do |dir|
    file_stat = File::Stat.new(dir)
    file_stat_mode = file_stat.mode.to_s(8).rjust(6)
    file_type = file_stat_mode[0, 3]
    file_permission = file_stat_mode[3, 3]
    file_type_char = file_type_table(file_type)
    file_permission_char = (0..2).map { |n| file_permissions_table(file_permission[n]) }.join
    file_nlink = file_stat.nlink
    file_owner = Etc.getpwuid(file_stat.uid).name
    file_group = Etc.getgrgid(file_stat.gid).name
    file_size = file_stat.size
    timestamp = file_stat.mtime.strftime('%-m %e %H:%M')

    puts "#{file_type_char}#{file_permission_char}  #{file_nlink} #{file_owner}  #{file_group}   #{file_size}  #{timestamp} #{dir}"
  end
end

def file_type_table(file_type)
  {
    ' 20': 'c',
    ' 60': 'b',
    ' 40': 'd',
    '100': '-',
    '120': 'l'
  }[file_type.to_sym]
end

def file_permissions_table(file_type)
  {
    '0': '---',
    '1': '--x',
    '2': '-w-',
    '3': '-wx',
    '4': 'r--',
    '5': 'r-x',
    '6': 'rw-',
    '7': 'rwx'
  }[file_type.to_sym]
end

def arrange_without_option(directories)
  num_of_slice = (directories.count / 3.0).ceil

  directories_matrix = []
  directories.each_slice(num_of_slice) do |x|
    x << nil until x.size == num_of_slice
    directories_matrix << x
  end

  transeposed_directories = directories_matrix.transpose

  max_lengh_of_words = directories.max_by(&:length).length

  transeposed_directories.each do |dirs|
    dirs.each do |dir|
      print "#{dir.ljust(max_lengh_of_words)}  " unless dir.nil?
    end
    print "\n"
  end
end

option = ARGV.getopts('alr')
main(option)
