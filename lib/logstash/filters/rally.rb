# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

# This example filter will replace the contents of the default
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an example.
class LogStash::Filters::Rally < LogStash::Filters::Base


  config_name "rally"

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   rally {
  #     uniqueid => [ "fieldname" ]
  #   }
  # }
  #
  config :uniqueid, :validate => :array
  
  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  #   filter {
  #    rally {
  #       cusum_field => [fieldname]
  #     }
  #   }
  #
  config :cusum_field, :validate => :array
  
  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #   rally {
  #     weather => [ "projectsName" => "weather" ]
  #   }
  # }
  #
  config :weather, :validate => :array

# declaration of variables....!!!!!!!!!!!!!!!! 
  public
  def register
    # Add instance variables
    $index=0
     
    $i1=0
    $j1=0
    $k1=0
    $temp1 = Array.new()
    $metrics1 = Array.new()
    
    $i=0
    $j=0
    $k=0
    $temp = Array.new()
    $tempWeather = Array.new()
    $tempProjects = Array.new()
    $tempProjects[0]= "null"
    $metrics = Array.new()

  end # def register

  public
  def filter(event)
    # filter_matched should go in the last line of our successful code
    uniqueid(event) if @uniqueid
    cusum_field(event) if @cusum_field
    weather(event) if @weather
    filter_matched(event)
  end # def filter

# uniqueid method begins...........!!!!!!!!!!!!!!!!   
  def uniqueid(event)
  
    @uniqueid.each do |field|
      $index = ($index + 1) 
      event[field] = $index
    end # end @uniqueid.each do
  end # end def uniqueid(event)
  
# uniqueid method ends...........!!!!!!!!!!!!!!!!     

# cusum_field method begins...........!!!!!!!!!!!!!!!!   
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
  
# cusum_field method ends...........!!!!!!!!!!!!!!!!

# weather method begins...........!!!!!!!!!!!!!!!!
  def weather(event)  #newly added
    @weather.each do |projects, weather|
      $i += 1 
      $tempProjects[$i] = event[projects]
      $tempWeather[$i] = event[weather]
    end # end @weather.each do |projects, weather|
    
    @weather.each do |projects, weather|
      $j += 1
      if $tempProjects[$j-1] == event[projects]
            
         if  $b==1
             $b=0
             $c=1
             result=$tempWeather[$j-1].to_f
             $metrics[$j] = result
         elsif $c==1
             $c=0
             x=$tempWeather[$j-2].to_f
             y=$tempWeather[$j-1].to_f
             result = (x+y)/2
             $metrics[$j] = result
         else
            x = $tempWeather[$j-3].to_f
            y = $tempWeather[$j-2].to_f
            z = $tempWeather[$j-1].to_f
            result = (x+y+z)/3
            $metrics[$j] = result
         end # end if $j==1
      else
         $b=1
         result=0
         $metrics[$j] = result 
      end # end $tempProject[$j-1] == event[projects]
    end # end @weather.each do |projects, weathers|
    
    @weather.each do |projects, weather|
      $k += 1
      result = $metrics[$k] 
      event[weather] = result.to_f
      event[projects] = $tempProjects[$k]
    end # end  @weather.each do |weather| 
  end # end def weather(event)

# weather method ends...........!!!!!!!!!!!!!!!!
  
end # class LogStash::Filters::Rally
