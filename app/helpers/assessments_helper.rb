module AssessmentsHelper
  def questionnaire_field(assessment, question_id, question_hash, prefix="result")
    name = "#{prefix}[assessment_answers][]"
    answer_name = name + "[answer]"
    question_name = name + "[question_id]"
    answer_id = question_hash[:type] == :dropdown ? "select_#{Time.zone.now.to_i}#{Time.zone.now.usec}" : "result_assessment_answers_#{question_id}"

    if assessment
      assessment_results =  assessment.assessment_results.select{|ar| ar.question_id.to_i == question_id.to_i}
      answer = assessment_results.empty? ? nil : assessment_results.first.answer
    end

    l = label_tag answer_id, question_hash[:text]
    s = hidden_field_tag question_name, question_id
    r = case question_hash[:type]
      when :dropdown
        select_tag(answer_name, options_for_select([['---', nil]] + question_hash[:options].invert.to_a, answer), {rel: "chosen", id: answer_id, class: 'form-control'  })
      when :integer
        number_field_tag(answer_name, answer, id: answer_id, class: 'form-control')
      when :date
        text_field_tag answer_name, answer, class: 'datepicker form-control', id: answer_id
      else
        text_field_tag answer_name, answer, id: answer_id, class: 'form-control'
    end

    content_tag :div do
      l + s + r
    end
  end
end


