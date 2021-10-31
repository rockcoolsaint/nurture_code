input = {
  "events": [
    {
      "url": '/pages/a-big-river',
      "visitorId": 'd1177368-2310-11e8-9e2a-9b860a0d9039',
      "timestamp": 1_512_754_583_000
    },
    {
      "url": '/pages/a-small-dog',
      "visitorId": 'd1177368-2310-11e8-9e2a-9b860a0d9039',
      "timestamp": 1_512_754_631_000
    },
    {
      "url": '/pages/a-big-talk',
      "visitorId": 'f877b96c-9969-4abc-bbe2-54b17d030f8b',
      "timestamp": 1_512_709_065_294
    },
    {
      "url": '/pages/a-sad-story',
      "visitorId": 'f877b96c-9969-4abc-bbe2-54b17d030f8b',
      "timestamp": 1_512_711_000_000
    },
    {
      "url": '/pages/a-big-river',
      "visitorId": 'd1177368-2310-11e8-9e2a-9b860a0d9039',
      "timestamp": 1_512_754_436_000
    },
    {
      "url": '/pages/a-sad-story',
      "visitorId": 'f877b96c-9969-4abc-bbe2-54b17d030f8b',
      "timestamp": 1_512_709_024_000
    }
  ]
}

def unique(input)
  output = { sessionsByUser: {} }
  users = []
  unique_events = input[:events].uniq { |evt| evt[:visitorId] }

  unique_events.each { |evt| users << evt[:visitorId] }

  list = {}
  users.each do |k|
    output[:sessionsByUser][k] = []
    filtered_list = input[:events].select { |event| event[:visitorId] == k }
    filtered_list.sort_by!{ |event| event[:timestamp] }

    url_list = []
    time_list = []
    session = {
      duration: 0,
      pages: url_list,
      startTime: nil
    }

    filtered_list.each_with_index do |event, index|
      prev_event = index == 0 ? filtered_list[0] : filtered_list[index - 1]
      if !((event[:timestamp] - prev_event[:timestamp]).abs <= 600000)
        output[:sessionsByUser][k] << {
          duration: 0,
          pages: [event[:url]],
          startTime: event[:timestamp]
        }

        time_list = [event[:timestamp]]
        url_list = [event[:url]]
      else
        url_list << event[:url]
        time_list ||= []
        time_list << event[:timestamp]
        duration = time_list.max - time_list.min
        
        session = {
          duration: duration,
          pages: url_list,
          startTime: time_list.min
        }
      end
    end

    output[:sessionsByUser][k] << session
    output[:sessionsByUser][k].sort_by! { |i| i[:startTime] }
  end

  puts output
end

unique(input)







# {
#   :sessionsByUser=>{
#     "d1177368-2310-11e8-9e2a-9b860a0d9039"=>[
#       {
#         :duration=>195000,
#         :pages=>["/pages/a-big-river", "/pages/a-big-river", "/pages/a-small-dog"],
#         :startTime=>1512754436000
#       }
#     ],
#     "f877b96c-9969-4abc-bbe2-54b17d030f8b"=>[
#       {
#         :duration=>0,
#         :pages=>["/pages/a-sad-story"],
#         :startTime=>1512711000000
#       },
#       {
#         :duration=>41294, 
#         :pages=>["/pages/a-sad-story", "/pages/a-big-talk"],
#         :startTime=>1512709024000
#       }
#     ]
#   }
# }
