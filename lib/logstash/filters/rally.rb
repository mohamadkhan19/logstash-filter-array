# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Rally < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  #   filter {
  #    rally {
  #       cusum_field => [fieldname]
  #     }
  #   }
  #
  config_name "rally"

  # Replace the message with this value.
  config :cusum_field, :validate => :array
  config :weather, :validate => :array


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)
    # filter_matched should go in the last line of our successful code
    cusum_field(event) if @cusum_field
    weather(event) if @weather
    filter_matched(event)
  end # def filter
  
   private  
    $i1=0
    $j1=0
    $k1=0
    $temp1 = Array.new()
    $metrics1 = Array.new()
    
    $i=0
    $j=0
    $k=0
    $temp = Array.new()
    $metrics = Array.new()
   
   
  def cusum_field(event)
    
    @cusum_field.each do |field|
      $i1 += 1 
      $temp1[$i1] = event[field]
     end # end do 
     
     while $j1 < $i1
       $j1 += 1
       if $j1==1
         result= $temp1[$j1]
         $metrics1[$j1] = result
     else
        x = $temp1[$j1].to_f
        y = $metrics1[$j1-1]
        result = (x+y)
        $metrics1[$j1] = result
     end # end if
     end # end while
     
     @cusum_field.each do |field|
      $k1 += 1
      result = $metrics1[$k1] 
      event[field] = result.to_f
    end # end  @cusum_field.each do    
  end # end cusum_field(event)
  
    def weather(event)
    
    @weather.each do |field|
      $i += 1 
      $temp[$i] = event[field]
     end # end do 
     
     while $j < $i 
       $j += 1
       if $j==1
         result=0
         $metrics[$j] = result
     elsif $j==2
         result=$temp[1].to_f
         $metrics[$j] = result
     elsif $j==3
         x=$temp[1].to_f
         y=$temp[2].to_f
         result = (x+y)/2
         $metrics[$j] = result
     else
        x = $temp[$j-3].to_f
        y = $temp[$j-2].to_f
        z = $temp[$j-1].to_f
        result = (x+y+z)/3
        $metrics[$j] = result
     end # end if
     end # end while
     
     @weather.each do |field|
      $k += 1
      result = $metrics[$k] 
      event[field] = result.to_f
    end # end  @weather.each do    
  end # end weather(event)
  
end # class LogStash::Filters::Rally
