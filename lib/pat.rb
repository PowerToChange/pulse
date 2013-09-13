module Pat
  def project_acceptance_totals(campus_ids, secondary_sort = {})
    params = { :campus_ids => campus_ids, :secondary_sort => secondary_sort }
    if Rails.env.development?
      puts "/projects/campus_project_acceptance_totals?#{params.to_query}"
      res = Net::HTTP.get_response("localhost", "/projects/campus_project_acceptance_totals?#{params.to_query}", 3001)
    else
      puts "/projects/campus_project_acceptance_totals?#{params.to_query}"
      url = URI.parse("https://pat.powertochange.org/projects/campus_project_acceptance_totals?#{params.to_query}")
      http = Net::HTTP.new url.host, url.port
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      res = nil
      http.start do |agent|
        puts "#{url.path}?#{url.query}"
        res = agent.get("#{url.path}?#{url.query}")
      end
    end

    return YAML::load(res.body)
  end

  def project_applying_totals(campus_ids)
    params = { :campus_ids => campus_ids }
    if Rails.env.development?
      res = Net::HTTP.get_response("localhost", "/projects/campus_project_applying_totals?#{params.to_query}", 3001)
    else
      url = URI.parse("https://pat.powertochange.org/projects/campus_project_applying_totals?#{params.to_query}")
      http = Net::HTTP.new url.host, url.port
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      res = nil
      http.start do |agent|
        puts url.path
        res = agent.get("#{url.path}?#{url.query}")
      end
    end

    return YAML::load(res.body)
  end

  def projects_count_hash(project_ids = nil)
    params = project_ids.present? ? { :project_ids => project_ids } : {}
    if Rails.env.development?
      res = Net::HTTP.get_response("localhost", "/projects/projects_count_hash?#{params.to_query}", 3001)
    else
      url = URI.parse("https://pat.powertochange.org/projects/projects_count_hash?#{params.to_query}")
      http = Net::HTTP.new url.host, url.port
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.use_ssl = true
      res = nil
      http.start do |agent|
        puts url.path
        res = agent.get("#{url.path}?#{url.query}")
      end
    end

    return YAML::load(res.body)
  end
end
