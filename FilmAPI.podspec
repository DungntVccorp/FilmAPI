Pod::Spec.new do |s|
s.name             = "FilmAPI"
s.version          = "1.0.1"
s.summary          = "DzLib dungnt Collection liblary FilmAPI Movie DB"
s.homepage         = "https://github.com/DungntVccorp/FilmAPI.git"
s.license          = 'Apache License'
s.author           = { "dung.nt" => "dung.nt.a5901679@gmail.com@gzone.com.vn" }
s.source           = { :git => "https://github.com/DungntVccorp/FilmAPI.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/FilmAPI/*.{h,m}'
s.dependency 'hpple'
s.dependency 'AFNetworking'
s.dependency 'DzCategory'
s.dependency 'XMLDictionary'
s.dependency 'FCFileManager'


end