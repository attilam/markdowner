
# Markdowner

## What is this thing?

Markdowner is a small, markdown-based static website generator.

The goal was for me to learn some Ruby, have an actual product at the end, and make it fit into a weekend project.

It's not stable or complete by any standards and it could erase your hard drive for all I know. 

If you're new to Ruby, like I am, there might be some handy links in the code. If you're a Ruby veteran, you will probably /facepalm a lot, and I'd love to hear your thoughts :)

A demo can be seen [here](http://attilam.com/downer/).

## Requirements

The BlueCloth 2.0.0 gem is required, I only tested it on Mac OS X Lion, with Ruby 1.8.7.

## Usage

    ruby publish.rb

Configuration is done in publish.rb:

	markdowner = Markdowner.new({
		:posts_dir => './posts/',
		:dest_dir => './web/',
		:base_url => "http://attilam.com/downer",
		:feature_first_post => true,
		:time_format => "%Y-%b-%d",
		:rss_name => 'rss.xml',
		:clean_dest_dir => true,
	})

The output can be customized using the files in the templates folder:

**index.html** - the index, variables: {article_list}, {rss_url}, {base_url}<br>
**post.html** - a single post, variables: {title}, {ctime}, {content}, {base_url}<br>
**rss.xml** - RSS feed, variables: {build_date}, {items}, {base_url}

## Credits, Reference

Markdowner was inspired by Steven Frank's PHP-based cms, [Laguna](http://code.google.com/p/laguna-blog/).

There are a fair few links in the code with links to sites where I found solutions to problems.