require 'mechanize'

module Adomachi
  class Archive < Base
    DAYS_SELECTOR = '.dataArea .kako-dataBOX a'

    def self.fetch(id = nil, selector: )
      agent = Mechanize.new
      page = agent.get "#{BASE_URL}/#{id}"
      page.search(selector)
    end

    def self.year_and_months
      years = (2002..(Time.now.year - 1)).to_a
      months = (1..12).to_a

      yms =
        [2001].product((7..12).to_a) +
        years.product(months) +
        [Time.now.year].product((1..Time.now.month).to_a)
      yms.map do |ym|
        y = ym[0].to_s
        m = ym[1].to_s.rjust(2, '0')
        "#{y}#{m}"
      end
    end

    def self.days(on: )
      elements = fetch(on, selector: DAYS_SELECTOR)
      elements.map do |elm|
        elm[:href].match(/backnumber\/(\d+)/)[1]
      end
    end
  end
end
