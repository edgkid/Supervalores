require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
scheduler = Rufus::Scheduler.singleton


start = false

unless start
  scheduler.every '5s' do
    # Rails.logger.info "hello, it's #{Time.now}"
    # puts User.first.nombre
    # Rails.logger.flush
    puts 'start: true'
    start = true
  end
end

if start
  scheduler.every '5s' do
    puts 'Started!'
  end
end