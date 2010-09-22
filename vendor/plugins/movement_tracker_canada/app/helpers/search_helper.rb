module SearchHelper
  unloadable

  def profile_picture_for_person(person)
    if person.filename.blank?
      image_tag('no_photo_blank.png', :width => '100%')
    else
      image_tag(person.filename(:mini), :width => '100%')
    end
  end

  def ac_profile_picture_for_person(person)
    if person.filename.blank?
      image_tag('no_photo_blank.png', :height => '100%')
    else
      image_tag(person.filename(:mini), :height => '100%')
    end
  end

  def info_for_person(person)
    info = ""

    if person.staff_role_ids.blank?
      # they are a student
      if person.campuses_concat.present?
        info += "#{person.campuses_concat}"
        info += (person.year_desc.blank? || person.year_desc == "Other") ? "<br/>" : "<strong> · </strong>#{person.year_desc}<br/>"
      end
    else
      # they are a staff
      info += person.ministries_concat.present? ? "#{person.ministries_concat}<strong> · </strong>Staff<br/>" : "Staff<br/>"
    end

    info += "#{person.email.downcase}" if person.email.present?

    if person.cell_phone.present?
      info += "<strong> · </strong>" if person.email.present?
      info += "#{number_to_phone(person.cell_phone)} (cell)<br/>"
    elsif person.person_local_phone.present?
      info += "<strong> · </strong>" if person.email.present?
      info += "#{number_to_phone(person.person_local_phone)}<br/>"
    elsif person.person_phone.present?
      info += "<strong> · </strong>" if person.email.present?
      info += "#{number_to_phone(person.person_phone)}<br/>"
    end

    info
  end

  def ac_info_for_person(person)
    info = ""
    if person.staff_role_ids.blank?
      info += "#{person.campuses_concat}<br/>" if person.campuses_concat.present?
    else
      info += "#{person.ministries_concat}<br/>" if person.ministries_concat.present?
    end

    info += "#{person.email.downcase}" if person.email.present?
  end
 
end

