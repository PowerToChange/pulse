module Pat
  def project_acceptance_totals(campus_ids, secondary_sort = {})
    params = { :campus_ids => campus_ids, :secondary_sort => secondary_sort }
    res = Net::HTTP.get_response("pat.powertochange.org", "/projects/campus_project_acceptance_totals?#{params.to_query}", 80)
    return JSON.parse(res.body)
  end

  def project_applying_totals(campus_ids)
    params = { :campus_ids => campus_ids }
    res = Net::HTTP.get_response("pat.powertochange.org", "/projects/campus_project_applying_totals?#{params.to_query}", 80)
    return JSON.parse(res.body)
  end

  def projects_count_hash
  end
end
