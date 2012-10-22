module AssessmentsHelper
  def questionnaire_field(assessment, question_id, question_hash, prefix="result")
    name = "#{prefix}[assessment_answers][#{question_id}]"

    if assessment
      assessment_results = assessment.assessment_results.where(question_id: question_id)
      answer = assessment_results.empty? ? nil : assessment_results.first.answer
    end


    case question_hash[:type]
      when :dropdown
        select_tag(name, options_for_select([['---', nil]] + question_hash[:options].invert.to_a, answer), class: "chosen")
      when :integer
        number_field_tag(name, answer)
      when :date
        text_field_tag name, answer, class: 'datepicker'
      else
        text_field_tag name, answer
    end
  end
end


