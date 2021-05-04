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

frames = shots.each_slice(2).map { |x| x }

if frames.length == 11 && frames[9][0] != 10
  frames[9] << frames[10][0]
  frames.pop
end

if frames.length == 11 && frames[9][0] == 10
  frames[9].delete_at(-1)
  frames[9] << frames[10][0]
  frames[9] << frames[10][0]
  frames.pop
end

if frames.length == 12
  frames[9].delete_at(-1)
  frames[9] << frames[10][0]
  frames[9] << frames[11][0]
  2.times { frames.pop }
end

sum_score = 0
frames.each.with_index(1) do |frame, i|
  if i <= 8 && frame[0] == 10 && frames[i][0] == 10 # 2連続ストライクの場合の処理
    sum_score += frames[i][0] + frames[i + 1][0]
  elsif frame[0] == 10 # ストライク単発の処理
    sum_score += frames[i][0] + frames[i][1] if i <= 9
  elsif frame.sum == 10 # スペアの処理
    sum_score += frames[i][0] if i <= 9
  end

  sum_score += frame.sum
end

puts sum_score
