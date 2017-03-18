class Page < ApplicationRecord
  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36'

  def self.find_or_download(link)
    begin
      self.find_or_create_by(link: link) do |p|
        p.body = download(link)
      end
    rescue ActiveRecord::StatementInvalid
      raise PageError, "Unable to store page"
    end
  end

  private

  def self.download(link)
    #todo handle requests errors
    #response = HTTParty.get(link, {timeout: timeout})
    begin
      response = HTTParty.get(link, headers: {"User-Agent" => USER_AGENT})
    rescue
      raise PageError, 'Unable to retrieve page'
    end

    begin
      strip_body(response.body)
    rescue
      raise PageError, 'Unable to parse page'
    end
  end

  def self.strip_body(body)
    doc = Nokogiri::HTML(body)
    doc.css('script, link, css').each { |node| node.remove }
    doc.text
  end

  def timeout
    10
  end
end
