Pod::Spec.new do |s|
  s.name               = "WebSocketRails-iOS"
  s.version            = 'v0.0.0'
  s.summary            = 'WebSocketRails client for iOS.'
  s.homepage           = 'https://github.com/patternoia/WebSocketRails-iOS'
  s.authors            = 'patternoia'
  s.license            = 'MIT License'
  s.source             = { :git => 'https://github.com/yackle/WebSocketRails-iOS', :commit => '6f19e4172a60fc7701a3b7eb49329518801a176c' }
  s.source_files       = 'WebSocketRails-iOS/*.{h,m,c}'
  s.requires_arc       = true
  
  s.dependency 'SocketRocket'
end