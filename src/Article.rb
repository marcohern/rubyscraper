
require 'digest'

class Article
  attr_accessor :selector, :image, :date, :category, :title, :uri, :body, :domain

  def initialize
    @domain = ''
    @image = ''
    @uri = ''
    @title = ''
    @body = ''
    @category = ''
    @date = ''
  end

  def md5
    Digest::MD5.hexdigest (@domain+@uri+@title+@body)
  end
end