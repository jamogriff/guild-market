class GithubService

  def self.repo_details
    response = conn.get('/repos/jamogriff/little-esty-shop')
    validate_conn(response)
  end

  def self.num_merged_prs
    response = conn.get('/repos/jamogriff/little-esty-shop/pulls?state=all')
    validated_response = validate_conn(response)
    validated_response.count do |pr|
      pr[:merged_at]
    end
  end

  def self.contributors
    team_usernames = ['netia1128', 'suzkiee', 'jamogriff', 'Jaybraum']
    response = conn.get('/repos/jamogriff/little-esty-shop/contributors')
    validated_response = validate_conn(response)

    validated_response.each_with_object({}) do |login, hash|
      if team_usernames.include? login[:login]
        hash[login[:login]] = login[:contributions]
      end
    end
  end

  private

  def self.conn
    Faraday.new('https://api.github.com') do |faraday|
      faraday.headers['Authorization'] = ENV['github-api-key']
    end
  end

  def self.validate_conn(response)
    if response.status != 200
      raise ApiConnectionError
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end

end
