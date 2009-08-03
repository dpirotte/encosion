# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{encosion}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rob Cameron"]
  s.date = %q{2009-08-03}
  s.email = %q{cannikinn@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "encosion.gemspec",
     "lib/encosion.rb",
     "lib/encosion/base.rb",
     "lib/encosion/cue_point.rb",
     "lib/encosion/exceptions.rb",
     "lib/encosion/image.rb",
     "lib/encosion/playlist.rb",
     "lib/encosion/rendition.rb",
     "lib/encosion/video.rb",
     "test/encosion_test.rb",
     "test/movie.mov",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/cannikin/encosion}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Ruby library for working with the Brightcove API}
  s.test_files = [
    "test/encosion_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpclient>, [">= 2.1.5.2"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.7"])
    else
      s.add_dependency(%q<httpclient>, [">= 2.1.5.2"])
      s.add_dependency(%q<json>, [">= 1.1.7"])
    end
  else
    s.add_dependency(%q<httpclient>, [">= 2.1.5.2"])
    s.add_dependency(%q<json>, [">= 1.1.7"])
  end
end
