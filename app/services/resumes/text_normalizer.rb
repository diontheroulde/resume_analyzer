class Resumes::TextNormalizer
  def self.call(raw_text)
    text = raw_text.dup
    text = text.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    text = text.gsub(/(\w)-\n(\w)/, '\1\2')
    text = text.gsub(/[•●▪‣◦]/, '- ')
    text = text.gsub(/[ \t]{2,}/, ' ')
    text = text.gsub(/\n{3,}/, "\n\n")
    text.strip
  end
end
