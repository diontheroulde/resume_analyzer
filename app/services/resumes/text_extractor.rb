class Resumes::TextExtractor
  def self.call(source)
    reader = PDF::Reader.new(source)
    text = reader.pages.map(&:text).join
    Resumes::TextNormalizer.call(text)
  end
end
