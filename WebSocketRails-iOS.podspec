Pod::Spec.new do |s|
  s.name               = "WebSocketRails-iOS"
  s.version            = '0.0.1'
  s.summary            = 'WebSocketRails client for iOS.'
  s.homepage           = 'https://github.com/patternoia/WebSocketRails-iOS'
  s.authors            = 'patternoia'
  s.license            = { :type => 'MIT', :file => 'LICENSE' }
  s.source             = { :git => 'https://github.com/yackle/WebSocketRails-iOS.git', :commit => '83a7e1a441c4895d150d97c9a60474466dd7f1a0' }
  s.source_files       = 'WebSocketRails-iOS/*.{h,m,c}'
  s.requires_arc       = true
  
  s.dependency 'SocketRocket'
end
