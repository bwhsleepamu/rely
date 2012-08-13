module AssessmentsHelper
  def questionnaire_field(question_hash)
    name = "assessment[#{question_hash[:id]}]"
    case question_hash[:type]
      when :dropdown
        select_tag(name, options_for_select(question_hash[:options]))
      when :integer
        number_field_tag(name)
      when :date
        text_field_tag name, '', class: 'datepicker'
      else
        text_field_tag name
    end
  end
end


