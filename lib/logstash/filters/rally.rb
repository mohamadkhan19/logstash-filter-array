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


  public
  def register
    # Add instance variables
  end # def register

  public
  def filter(event)
    # filter_matched should go in the last line of our successful code
    cusum_field(event) if @cusum_field
    filter_matched(event)
  end # def filter
  
   private  
    $i=0
    $j=0
    $k=0
    $temp = Array.new()
    $metrics = Array.new()
   
   
  def cusum_field(event)
    
    @cusum_field.each do |field|
      $i += 1 
      $temp[$i] = event[field]
     end # end do 
     
     while $j < $i 
       $j += 1
       if $j==1
         result= $temp[$j]
         $metrics[$j] = result
     else
        x = $temp[$j].to_f
        y = $metrics[$j-1]
        result = (x+y)
        $metrics[$j] = result
     end # end if
     end # end while
     
     @cusum_field.each do |field|
      $k += 1
      result = $metrics[$k] 
      event[field] = result.to_f
    end # end  @cusum_field.each do    
  end # end cusum_field(event)
  
end # class LogStash::Filters::Rally
