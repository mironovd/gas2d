class AveragingBucket
 def initialize
   @sum = 0
   @length = 0
   @average = 0
 end
 
 def <<(value)
   @sum += value
   @length += 1
   @average = nil
   self
 end
 alias push <<
 
 def average
   @average ||= @sum.to_f/@length
 end
 alias avg average

 def to_s
    @sum.to_s+"/"+@length.to_s+"="+@average.to_s
 end
end
