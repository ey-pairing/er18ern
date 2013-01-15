module Er18Ern
  class JustRaise
    def call(exception, locale, key, options)
      raise "Missing Translation: #{exception}"
    end
  end

  class RailsApp
    def self.setup!
      if ["test", "development"].include?(Rails.env)
        I18n.exception_handler = JustRaise.new
      end
      Array.class_eval do
        def to_br_sentence
          case length
            when 0
              ""
            when 1
              self[0].to_s.dup
            when 2
              two_words_connector = I18n.translate(:'support.array.br_two_words_connector')
              "#{self[0]}#{two_words_connector}#{self[1]}".html_safe
            else
              words_connector = I18n.translate(:'support.array.br_words_connector')
              last_word_connector = I18n.translate(:'support.array.br_last_word_connector')
              "#{self[0...-1].join(words_connector)}#{last_word_connector}#{self[-1]}".html_safe
          end
        end
      end
      ActiveModel::Errors.class_eval do
        def full_message(attribute, message)
          return message if attribute == :base
          attr_name = attribute.to_s.tr('.', '_').humanize
          attr_name = @base.class.human_attribute_name(attribute, :default => attr_name)
          I18n.t(:"errors.formats.attributes.#{attribute}", {
            :default   => [:"errors.format","%{attribute} %{message}"],
            :attribute => attr_name,
            :message   => message
          })
        end
      end
    end
  end
end