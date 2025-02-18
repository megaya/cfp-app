class SpeakerDecorator < ApplicationDecorator
  delegate_all
  decorates_association :proposals
  decorates_association :program_sessions

  def gravatar
    image_url =
      "https://www.gravatar.com/avatar/#{object.gravatar_hash}?s=50"

    h.image_tag(image_url, class: 'pull-left speaker-image')
  end

  def name_and_email
    "#{object.name} (#{object.email})"
  end

  def github_account
    user&.github_account.presence || (user&.github_uid.presence && github_uid_to_uname(user.github_uid))
  end

  def twitter_account
    user&.twitter_account.presence || (user&.twitter_uid.presence && twitter_uid_to_uname(user.twitter_uid))
  end

  def social_account
    twitter_account || github_account || (user&.name || speaker_name).downcase.tr(' ', '_')
  end

  def link_to_github
    if user&.github_uid.presence
      uname = github_uid_to_uname user.github_uid
      h.link_to "@#{uname}", "https://github.com/#{uname}", target: '_blank'
    else
      'none'
    end
  end

  private def github_uid_to_uname(uid)
    api_uri = URI.parse "https://api.github.com/user/#{uid}"
    Rails.cache.fetch api_uri do
      JSON.parse(Net::HTTP.get(api_uri))['login']
    end
  end

  def link_to_twitter
    if user&.twitter_uid.presence
      uname = twitter_uid_to_uname user.twitter_uid
      h.link_to "@#{uname}", "https://twitter.com/#{uname}", target: '_blank'
    else
      'none'
    end
  end

  private def twitter_uid_to_uname(uid)
    twitter_uri = "https://twitter.com/intent/user?user_id=#{uid}"
    Rails.cache.fetch twitter_uri do
      html = Net::HTTP.get URI.parse(twitter_uri)
      html.scan(/<span class="nickname">@(.*)<\/span>/).first&.first
    end
  end

  def bio
    object.bio.present? ? object.bio : object.user.try(:bio)
  end
end
