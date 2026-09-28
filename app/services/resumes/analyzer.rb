class Resumes::Analyzer
  def self.call(raw_text, job_description, keyword_report)
    client = OpenAI::Client.new

    response = client.chat.completions.create(
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "Judge the match only from the supplied text, and never invent skills, metrics, or experience.
                    Suggested wording may clarify what the resume already says, never inventing new claims.
                    Where a resume bullet describes an accomplishment without a number, note that as a keyword gap or wording suggestion prompting the candidate to quantify it if possible.
                    Also evaluate the resume's summary section as a pitch, not as evidence: does it state the candidate's role and strongest relevant qualifications in the first sentence,
                    use the job's key terminology, and stay focused on what this employer cares about? Flag content that doesn't serve the job. Any rewritten summary must use only facts already present in the resume."
        },
        {
          role: "user",
          content: "Resume:\n\n#{raw_text}\n\nJob Description:\n\n#{job_description}\n\n" \
           "Keyword check (computed by code, treat as fact):\n#{keyword_report.to_json}\n\n" \
           "Compare the resume against the job description."
        }
      ],
      tools: [ comparison_result_tool ],
      tool_choice: { type: "function", function: { name: "comparison_result" } }
    )

    tool_call = response.choices.first.message.tool_calls.first
    JSON.parse(tool_call.function.arguments)
  end

  def self.comparison_result_tool
    {
      type: "function",
      function: {
        name: "comparison_result",
        description: "Generates a comparison result between a resume and a job description",
        parameters: {
          type: "object",
          properties: {
            overall_score: { type: "integer", description: "Match score from 0-100 based on how well the resume aligns with the job requirements." },
            match_summary: { type: "string" },
            matched_requirements: { type: "array", items: { type: "string" } },
            missing_requirements: { type: "array", items: { type: "string" } },
            wording_suggestions: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  original: { type: "string" },
                  suggested: { type: "string" },
                  reason: { type: "string", description: "Why this change better aligns with the job description or improves clarity." }
                }
              }
            },
            total_years_experience: { type: "integer", description: "Total years of experience in the industry." },
            roles: { type: "array", items: { type: "string", description: "Roles held in the industry." } },
            resume_summary_feedback: {
              type: "object",
              description: "Evaluation of the resume's own summary/objective section against the job description. If the resume has no summary section, set present to false and suggest one using only facts from the resume.",
              properties: {
                present: { type: "boolean" },
                original: { type: "string", description: "The resume's summary text, copied verbatim. Empty if none." },
                strengths: { type: "array", items: { type: "string" } },
                weaknesses: { type: "array", items: { type: "string" }, description: "Specific issues relative to this job: missing keywords, generic phrasing, irrelevant content, too long, etc." },
                suggested: { type: "string", description: "A rewritten summary tailored to this job, using only facts already in the resume." }
              },
              required: [ "present", "strengths", "weaknesses", "suggested" ]
            }
          },
          required: [ "overall_score", "match_summary", "matched_requirements", "missing_requirements", "wording_suggestions", "resume_summary_feedback" ]
        }
      }
    }
  end
end
