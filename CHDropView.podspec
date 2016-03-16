Pod::Spec.new do |s|
    s.name         = 'CHDropView'
    s.version      = ‘1.0.0’
    s.summary      = 'An easy way to use drop-down menu'
    s.homepage     = 'https://github.com/stccon/CHDropView'
    s.license      = 'MIT'
    s.authors      = {'stccon' => '1013124327@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/stccon/CHDropView.git', :tag => s.version}
    s.source_files = 'CHDropView/**/*.{h,m}'
    s.requires_arc = true
end
