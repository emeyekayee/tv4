

class Program < ActiveRecord::Base
  self.table_name = 'program'

  has_many :genres, foreign_key: 'program'

  def category
    # genre.genre
    lgenre # table-local concatenation of genres
  end

  def category_type
    showType
  end

  def stars
    (starRating || '').split('').map{|c|  {'*' => 0.25, '+' => 0.125}[c] || 0 }.sum
  end


end
