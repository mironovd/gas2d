require './csvgroup.rb'
require './avgbucket.rb'
require 'pry'

x=Marshal.load(File.binread(ARGV[0]))

N=x[0]
@ma=x[1]

def loggrowth(c)
    (1..N-1).map{|t| @ma[t][(t*c).floor].avg }.map.with_index{|m,t| Math::log(m)-Math::log(t)}
end

binding.pry

p