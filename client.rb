require 'slack-ruby-client'
require '../enerbot/acl.rb'
require '../enerbot/Scripts/ssh'
require '../enerbot/Scripts/random'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  config.raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

def send_message(data, text, icon, username)
  client = Slack::RealTime::Client.new
  client.web_client.chat_postMessage channel: data.channel, text: text, icon_emoji: icon, username: username
end

def show_output(data, info, icon)
  client = Slack::RealTime::Client.new
  client.web_client.chat_postMessage as_user: true, channel: data.channel, text: "Oki <@#{data.user}>!", attachments: [{ fallback: 'Sup', title: 'Output', text: info.to_s }], icon_emoji: icon
end

client.on :message do |data|
  puts data
  case data.text
  when 'hola' then
    send_message(data, 'holiwis', ':black_square:', 'ENERBOT')
  when /como va/ then
    send_message(data, ':fire::evilparrot::fire:', ':fire:', 'EvilParrot')
  when 'savage mode' then
    send_message(data, 'Guau!', ':dog:', 'Doggo')
  when /consejo/, /pregunta/ then
    send_message(data, random_advice, ':black_square:', 'ENERBOT')
  when 'beneficio' then
    send_message(data, random_benefit, ':black_square:', 'ENERBOT')
  when 'musica' then
    send_message(data, random_music, ':notes:', 'MP3')
  when 'party' then
    send_message(data, ':partyparrot:', ':star:', 'PARTY PARROT')
  when /^bot/ then
    control(data.text.to_s, data.user.to_s, data.channel.to_s)
    if !$output.nil?
      ssh = show($output).to_s
      show_output(data, ssh, ':skull:')
    else
      send_message(data, "You don't have power here <@#{data.user}>!", ':male_mage:', 'Gandalf')
    end
  when 'self-destruct' then
    send_message(data, 'Adios mundo cruel', ':bomb:', 'ENERBOT')
    abort('Bye')
  end
end

client.start!