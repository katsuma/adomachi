require 'mechanize'
require 'json'
require 'csv'

module Adomachi
  class Program < Base
    def initialize(id)
      @id = id.to_s
      @agent = Mechanize.new
      @page = @agent.get "#{BASE_URL}/#{id}"
      @rank_pages = {}
    end

    def title
      @_title ||= @page.search('h4.zenkai_sub_title').text
    end

    def links
      @_links ||= @page.search('ul.location_list_box li a:first-child').map { |link| link[:href] }
    end

    def date
      @_date ||= Date.parse(@id)
    end

    def at(rank)
      link = links[rank - 1]
      rank_page = rank_page_at(link)

      rank_title = rank_page.search('div.location_box').inner_text.match(/(\d+)位(.+)/)[2]
      rank_description = rank_page.search('.Lower_zenkai_text').inner_html.gsub('<br>', "\n")

      {
        title: rank_title,
        description: rank_description,
      }
    end

    def ranking
      (1..10).map do |rank|
        { rank: rank, title: at(rank)[:title], description: at(rank)[:description] }
      end
    end

    def to_s
      {
        title: title,
        date: date,
        ranking: ranking
      }.to_s
    end

    def to_json
      {
        title: title,
        date: date,
        ranking: ranking
      }.to_json
    end

    def to_csv(file_path)
      CSV.open(file_path, 'wb') do |csv|
        csv << [title, date]
        ranking.each do |rank|
          csv << ["#{rank[:rank]}位", rank[:title], rank[:description]]
        end
      end
    end

    def rank_page_at(link)
      unless @rank_pages[link]
        @rank_pages[link] = @agent.get(link)
      end
      @rank_pages[link]
    end
    private :rank_page_at

  end
end
