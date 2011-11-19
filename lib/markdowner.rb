# = Markdowner
#
# 2011 attilam.com
#
# A small, markdown-based static website generator.
#
# This is a learning project, it's unstable.
# Feel free to do whatever you like with it.
#

require 'find'
require 'fileutils'

require 'post'

# == Markdowner class
#
# Collects markdown-based posts and generates html, index, and RSS
#
class Markdowner
	attr_accessor :config

	def initialize( config )
		@config = config
		
		# make sure base url ends with /
		unless @config[:base_url].length == 0
			if @config[:base_url][-1, 1] != "/"
				@config[:base_url] += "/"
			end
		end

		@post_template = read_text_file('templates/post.html')
		@index_template = read_text_file('templates/index.html')
		@rss_template = read_text_file('templates/rss.xml')
		
		@rss_url = @config[:base_url] + @config[:rss_name]
		@posts = Array.new
	end

	def publish
		collect_posts @config[:posts_dir]
		sort_posts
		
		if @config[:clean_dest_dir]
			clean_dest_dir
		end

		generate_all_posts

		generate_index
		
		generate_rss
	end

#
# === HELPER FUNCTIONS
#

	# Reference: http://rubylearning.com/satishtalim/read_write_files.html
	def read_text_file(fname)
		fdata = ""
		
		File.open(fname, 'r') do |fl|
			while line = fl.gets
				fdata = fdata + line
			end
		end
		
		fdata
	end

	def write_text_file(fname, content)
		File.open(@config[:dest_dir]+fname, 'w') do |fhandle|
			fhandle.puts content
		end
	end

	def collect_posts(base_dir)
		Find.find(base_dir) do |fname|
			if File.file?(fname) && fname.index('.markdown') then
				post = Post.new fname
				@posts << post
			end	
		end
	end

	# Reference: http://www.ruby-forum.com/topic/217985
	def clean_dest_dir
		FileUtils.rm Dir.glob(@config[:dest_dir]+"*.html")
		if File.exists? @config[:dest_dir]+"rss.xml"
			FileUtils.rm @config[:dest_dir]+"rss.xml"
		end
	end

	# Reference: http://stackoverflow.com/questions/2642182
	def sort_posts
		@posts = @posts.sort_by { |post| post.ctime }.reverse!
	end

	# Reference: http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime
	def format_time( time )
		time.strftime(@config[:time_format])
	end

	# Reference: http://feed2.w3.org/docs/error/InvalidRFC2822Date.html
	def format_time_RFC822( time )
		time.strftime("%a, %d %b %Y %H:%M:%S %z")
	end

	def get_post_permalink( post )
		@config[:base_url]+post.basename+".html"
	end

	def get_post_relative_link( post )
		post.basename+".html"
	end

#
# === GENERATOR FUNCTIONS
#

	def generate_index
		articlelist = ""
		
		if @config[:feature_first_post]
			first = true
		else
			first = false
		end
		@posts.each do |post|
			postdate = format_time post.ctime
			link = get_post_relative_link post
			articlelist += "<div class='postdate'>#{postdate}</div><div class='posttitle'><a href='#{link}'>#{post.title}</a></div><br>\n"
			
			if first
				articlelist += post.markdown.to_html
				articlelist += "<br><br>\n<div id='older'>Older Entries:</div>\n"
				first = false
			end
		end
		
		index = @index_template.sub( "{article_list}", articlelist )
		index = index.sub( "{rss_url}", @rss_url )
		index = index.gsub( "{base_url}", @config[:base_url] )

		write_text_file 'index.html', index
	end
	
	def generate_post(post)
		post_text = @post_template.gsub( "{title}", post.title )
		post_text = post_text.gsub( "{ctime}", format_time(post.ctime) )
		post_text = post_text.gsub( "{content}", post.markdown.to_html )
		post_text = post_text.gsub( "{base_url}", @config[:base_url] )

		write_text_file get_post_relative_link(post), post_text
	end

	def generate_all_posts
		@posts.each do |post|
			generate_post post
		end
	end
	
	def generate_rss
		items = ""
		@posts.each do |post|
			# RSS feed requires RFC-822 compliant date
			postdate = format_time_RFC822 post.ctime
			permalink = get_post_permalink post

			items << "<item>\n"
			items << "<title>#{post.title}</title>\n"
			items << "<description><![CDATA[#{post.markdown.to_html}]]></description>\n"
			items << "<link>#{permalink}</link>\n"
			items << "<guid>#{permalink}</guid>\n"
			items << "<pubDate>#{postdate}</pubDate>\n"
			items << "</item>\n"
		end
		
		rss = @rss_template.sub( "{build_date}", format_time_RFC822(Time.now) )
		rss = rss.sub( "{items}", items )
		rss = rss.gsub( "{base_url}", @config[:base_url] )

		write_text_file @config[:rss_name], rss
	end
end
