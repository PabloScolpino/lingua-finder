class Page
  include Mongoid::Document

  field :link, type: String
  field :body, type: String

  has_and_belongs_to_many :search_queries

  def self.find_or_download_by(id: id)
    page = find(id)
    page.body = download(page.link)
    page
  rescue EncodingError
    raise PageError, 'could not store page'
  end

  def id
    self[:_id].to_s
  end

  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2227.0 Safari/537.36'.freeze

  def self.download(link)
    # TODO: handle requests errors
    #   response = HTTParty.get(link, {timeout: timeout})
    begin
      response = HTTParty.get(link, headers: { 'User-Agent' => USER_AGENT })
    rescue StandardError
      raise PageError, 'Unable to retrieve page'
    end

    begin
      strip_body(response.body)
    rescue StandardError
      raise PageError, 'Unable to parse page'
    end
  end

  def self.strip_body(body)
    doc = Nokogiri::HTML(body)
    doc.css('script, link, css').each(&:remove)
    doc.text
  end
end
