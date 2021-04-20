#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |x|
  if x == 'X'
    shots << 10
    shots << 0
  else
    shots << x.to_i
  end
end

frames = []
shots.each_slice(2).map { |x| frames << x }

if frames.length == 11 && frames[9][0] != 10
  frames[9] << frames[10].shift
  frames.delete_at(10)
end

if frames.length == 11 && frames[9][0] == 10
  frames[9].delete_at(-1)
  frames[9] << frames[10].shift
  frames[9] << frames[10].shift
  frames.delete_at(10)
end

if frames.length == 12
  frames[9].delete_at(-1)
  frames[9] << frames[10].shift
  frames[9] << frames[11].shift
  2.times { frames.delete_at(10) }
end

sum_score = 0
frames.each.with_index(1) do |frame, i|
  if i <= 8 && frame[0] == 10 && frames[i][0] == 10 # 2連続ストライクの場合の処理
    sum_score += frames[i][0] + frames[i + 1][0]
  elsif i <= 8 && frame[0] == 10 # ストライク単発の処理
    sum_score += frames[i].sum
  elsif i <= 9 && frame.sum == 10 && frame[0] != 10 # スペアの処理
    sum_score += frames[i][0]
  elsif i == 9 && frame[0] == 10 # 9投目がストライクの場合の処理
    sum_score += frames[i][0] + frames[i][1]
  end

  sum_score += frame.sum
end

puts sum_score