# frozen_string_literal: true

Sidekiq::Logging.logger.level = Logger::WARN unless Rails.env.development?
