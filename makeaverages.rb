require './csvgroup.rb'
require './avgbucket.rb'

N=ARGV[0].to_i
dir=ARGV[1]

ma=(0..N).map{(0..N).map{AveragingBucket.new}}

Dir.glob(dir+'/*').each{|ff|
    File.readlines(ff).map{|ll| 
	l=ll.split(';')
	t=l.shift
	x=(0..N+1).map{0}
	y=(0..N+1).map{0}
	l.each_with_index{|k,i| x[i]=k.to_i}
	(0..N).to_a.reverse.each{|i| y[i]=y[i+1]+x[i]}
	y[0..N-1].each_with_index{|k,i| ma[t.to_i-1][i].push(k) } 
    }
}

(0..N).each{|t| (0..N).each{|i| ma[t][i].avg}}

File.open("ma."+dir+".marshall","wb"){|o| o.puts(Marshal.dump(ma))}

p ma


