#!/usr/bin/ruby
#
# = Markdowner
#
# 2011 attilam.com
#
# A small, markdown-based static website generator.
#
# This is a learning project, it's unstable.
# Feel free to do whatever you like with it.
#

$:.unshift(File.join(File.dirname(__FILE__), "lib")).unshift('lib')

require 'markdowner'

# markdowner = Markdowner.new './posts/', './web/'

markdowner = Markdowner.new({
	:posts_dir => './posts/',
	:dest_dir => './web/',
	:base_url => "http://attilam.com/downer",
	:feature_first_post => true,
	:time_format => "%Y-%b-%d",
	:rss_name => 'rss.xml',
	:clean_dest_dir => true,
})

markdowner.publish