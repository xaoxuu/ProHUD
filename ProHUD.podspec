Pod::Spec.new do |s|
  s.name = 'ProHUD'
  s.version = "1.0"
  s.license = 'MIT'
  s.summary = '可完全定制化的HUD，包含顶部区域的Toast，中央区域的Alert和底部区域的ActionSheet。'
  s.homepage = "http://xaoxuu.com"
  s.authors = { 'xaoxuu' => 'xaoxuu@gmail.com' }
  s.source = { :git => "https://github.com/xaoxuu/ProHUD.git", :tag => "#{s.version}", :submodules => false}

  s.ios.deployment_target = '9.0'

  s.source_files = 'ProHUD/**/*.swift'
  s.resource_bundles = { 'ProHUD' => ['ProHUD/*.{xcassets,strings,xml,storyboard,xib,xcdatamodeld,gif,lproj}'] }
  s.requires_arc = true
  s.swift_version = '5.0'

  s.dependency 'SnapKit', '4.2.0'
  s.dependency 'Inspire' 

end
