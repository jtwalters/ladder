module ApplicationHelper
  def gravatar_image_url(email, size = 16)
    hash = Digest::MD5.hexdigest(email.strip.downcase)
    "https://secure.gravatar.com/avatar/#{hash}?s=#{size}&d=identicon"
  end

  def gravatar_image_tag(email, size = 16, opts = {})
    image_tag gravatar_image_url(email, size), opts.merge!(:size => "#{size}x#{size}")
  end

  def cancel_link(path)
    link_to t('helpers.cancel_link'), path, :class => 'btn btn-default'
  end

  def delete_link(path)
    link_to t('helpers.submit.delete'), path, method: :delete, data: {confirm: 'Are you sure?'}, :class => 'btn btn-danger pull-right'
  end

  def markdown(text)
    sanitize Kramdown::Document.new(text).to_html.html_safe
  end

  def render_single(model)
    render [model].compact
  end

  def glyph(name)
    content_tag :span, "", class: "glyphicon glyphicon-#{name}"
  end

  def badge(content)
    content_tag :span, class: "badge" do
      "#{content}"
    end
  end
end
