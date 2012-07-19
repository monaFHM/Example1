require_relative 'GoogleGeoAPI'
require_relative '../common/CommonlyUsed'

@helper = Helper::CommonlyUsed.new
googleRequestConst="http://maps.googleapis.com/maps/api/geocode/json"
requestParamString='1600 Amphitheatre Parkway, Mountain View, CA'

p googleRequestConst
p @helper.make_Uri_String_from_Hash({'address' => requestParamString})


requestString=googleRequestConst+ @helper.make_Uri_String_from_Hash({'address' => requestParamString, 'sensor' => 'false'})
p requestString
ergebnis= @helper.request_Webservice(requestString)
p ergebnis

p ergebnis.body
