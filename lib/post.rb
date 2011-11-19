# = Markdowner
#
# 2011 attilam.com
#
# A small, markdown-based static website generator.
#
# This is a learning project, it's unstable.
# Feel free to do whatever you like with it.
#


require 'rubygems'
gem 'bluecloth', '>= 2.0.0'
require 'bluecloth'

require 'date'

# == Post class
#
# A blog entry, markdown-based content, and metadata
#
class Post
	attr_accessor :filename, :title, :ctime, :content, :author, :basename, :markdown
	
	def initialize( fname )
		@filename = fname
		@author = ""

		if File.exists?(fname)
			@ctime = File.ctime fname
			@content = read_from_file fname
		else
			@ctime = Time.now
			@content = "# Hello World!"
		end

		@basename = File.basename(@filename, '.markdown')
		@title = camelcase_to_title @basename

		@markdown = markdown_parse(@content)
	end
	
	def read_from_file(fname)
		fdata = ""

		File.open(fname, 'r') do |fl|
			while line = fl.gets
				fdata = fdata + line
			end
		end
		
		fdata
	end

	# Reference: http://epochwolf.com/using-bluecloth-20
	# pandoc_headers reference: http://johnmacfarlane.net/pandoc/demo/example9/pandocs-markdown.html#title-block
	def markdown_parse(str, options = {})
		options = {
			:strict_mode => false,
			:auto_links => true,
			:pandoc_headers => true,
		}.update(options)
		
		bc = BlueCloth.new(str, options)
		
		if defined? bc.header
			@title = bc.header[:title] || @title
			@author = bc.header[:author] || @author
			unless bc.header[:date].nil?
				@ctime = Time.parse bc.header[:date]
			end
		end
		bc
	end

	def camelcase_to_title(str)
		str.gsub(/(.)([A-Z])/, '\1 \2')
	end
	
	def get_info
		puts "Title: #{@title}"
		puts "Date: #{@time}"
	end
end
