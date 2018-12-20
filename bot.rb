require 'twitter'

config = {
  consumer_key:        ENV['KEY'],
  consumer_secret:     ENV['KEY_KEY'],
  access_token:        ENV['TOKEN'],
  access_token_secret: ENV['TOKEN_KEY']
}

rClient = Twitter::REST::Client.new(config)
sClient = Twitter::Streaming::Client.new(config)

################
#  DEPRECATED  #
################

# dClient = Twitter::DirectMessages.new(config)
# dClient.d('@USERNAME', 'LERN SEQUENCE')

topics = ['@enerofficial', '#enerbot', 'enerbot', 'enershut']
sClient.filter(track: topics.join(',')) do |tweet|
  if tweet.is_a?(Twitter::Tweet)
    user = tweet.user.screen_name
    id = tweet.id
    text = tweet.text

    abort('bye') if text.include? 'enershut'
    puts text
    mess = case text
           when /daily/
             'IVAN HACE EL PR'
           when /hola/i
             'Hola'
           when /i love enerbot/
             'i love you more'
           end
    rClient.fav
    rClient.update("@#{user} #{mess}", in_reply_to_status_id: id)
  end
end
