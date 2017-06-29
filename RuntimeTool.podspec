Pod::Spec.new do |s|
  s.name             = 'RuntimeTool'
  s.version          = '1.0'
  s.summary          = 'RuntimeTool.'
  s.description      = <<-DESC
  A convinent use tool for runtime.
                       DESC
  s.homepage         = 'https://github.com/guodongyangwen/RuntimeTool.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guodongyang' => 'guodongyang@qfpay.com' }
  s.source           = { :git => 'https://github.com/guodongyangwen/RuntimeTool.git', :tag => 1.0 }
  s.ios.deployment_target = '7.0'
  s.source_files = 'RuntimeTool/Classes/**/*'
  s.public_header_files = 'RuntimeTool/Classes/**/*.h'
end
