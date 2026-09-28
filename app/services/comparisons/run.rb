class Comparisons::Run
  def self.call(resume_text, job_description_text)
    keywords = Resumes::KeywordExtractor.call(job_description_text)
    report   = Ats::KeywordMatcher.call(resume_text, keywords)
    analysis = Resumes::Analyzer.call(resume_text, job_description_text, report)

    analysis.merge("keyword_report" => report)
  end
end
