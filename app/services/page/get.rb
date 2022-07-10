# frozen_string_literal: true

class Page
  class Get < ApplicationInteraction
    string :id

    def execute
      find_or_download(id)
    end

    private

    def find_or_download(id)
      page = Page.find(id)
      page.body = download(page.link) if page.body.blank?
      page.save!
    rescue EncodingError
      raise PageError, 'could not store page'
    end

    USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0 Safari/537.36'

    def download(link)
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

    def strip_body(body)
      doc = Nokogiri::HTML(body)
      doc.css('script, link, css').each(&:remove)
      doc.text
    end
  end
end
