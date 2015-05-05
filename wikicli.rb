#!/usr/bin/env ruby
#
# A program to talk to my wiki.
require 'mediawiki_api'
require 'getoptlong'
require 'yaml'

# Get config from ~/.wikiclirc
cf = File.join( ENV['HOME'], '.wikiclirc' )
if File.exist?( cf ) 
  conf = YAML.load(File.open(cf).read)
else 
  puts "Please create your configuration file (#{cf}); I expect user, password, apiurl."
  exit 1
end

user = conf['user']
pass = conf['password']
wiki_api = conf['apiurl']

if (user.length < 1 || pass.length < 1 )
  puts "Please make sure you properly configured #{cf}"
  exit 1
end

def help
  puts <<-HELP
wikicli [--verbose] <--action action> <--title page_title> [--help]

  * 'action' may be one of [get, update, append]
  * 'title' refers to the page title
  * Page content should be fed to standard input

Features coming soon:

  * action = delete

HELP
    exit 1
end


opts = GetoptLong.new(
  [ '--help','-h', GetoptLong::NO_ARGUMENT ],
  [ '--action', '-a', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--title', '-t', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--verbose', '-v', GetoptLong::OPTIONAL_ARGUMENT ]
)

action = nil
title = nil
verbose = 0

opts.each do |opt,arg|
  case opt
  when '--action'
    action = arg
  when '--title'
    title = arg
  when '--verbose'
    verbose += 1
  when '--help'
    help
  end
end

if action.nil? 
  help
end

if title.nil? && action != 'get'
  puts "\nMust specify title for update operations\n"
  help
end

if verbose
  puts "API endpoint #{wiki_api}"
end

client = MediawikiApi::Client.new wiki_api, verbose
client.log_in user, pass

# Action may be one of:
# get, update, append
# 
# Coming later: delete

case action
when 'get'
  reply = client.get_wikitext title
  puts reply.body
when 'update'
  content = STDIN.read
  reply = client.create_page title, content
  print reply.status
when 'append'
  reply = client.get_wikitext title
  content = STDIN.read
  content_new = reply.body + content
  reply = client.create_page title, content_new
when 'delete'
  print "Unimplemented"
end

