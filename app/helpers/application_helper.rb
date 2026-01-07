module ApplicationHelper
  def grade_color_class(grade)
    return 'text-muted' unless grade
    if grade >= 4.5
      'text-grade-5'
    elsif grade >= 3.5
      'text-grade-4'
    elsif grade >= 3
      'text-grade-3'
    else
      'text-grade-2'
    end
  end

  def attendance_color_class(percentage)
    return 'bg-secondary' unless percentage
    if percentage >= 80
      'bg-grade-5'
    elsif percentage >= 60
      'bg-grade-3'
    else
      'bg-grade-2'
    end
  end
end