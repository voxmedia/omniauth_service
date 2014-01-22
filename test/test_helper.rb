# add gem lib dir to the load path...
$:.unshift File.expand_path("../lib", File.dirname(__FILE__))

# require the gem
require 'omniauth_service'

# setup minitest
require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/pride'


