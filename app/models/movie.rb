class Movie < ActiveRecord::Base
  def self.ratings
    return Movie.find(:all, :select => 'rating').collect{ |mov| mov.rating}.uniq
  end

  def self.query(ratings)
    rati = ratings
    #rati.compact!
    ret = ""
    rati.each{ |s| ret += 'rating = "' + s[0].to_s + '" or ' }
    ret.chomp!(" or ")
    return ret
  end
end
