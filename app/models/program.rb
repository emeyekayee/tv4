

class Program < ActiveRecord::Base
  self.table_name = 'program'

  has_one :genre, foreign_key: 'program'

  def category
    genre.genre
  end

  def category_type
    showType
  end

  def stars
    (starRating || '').split('').map{|c|  {'*' => 0.25, '+' => 0.125}[c] || 0 }.sum
  end

  # See Event#get_visual_info()
  # def set_visual_info ()
  #   set_style_classes
  #   set_block_label
  # end
  
  # FKA set_block_label
  # def block_label  
  #   label = title
  #   label += ":<br/>&nbsp;#{self.subtitle}" if subtitle && subtitle.length > 0
  #   label.html_safe
  # end

  # FKA set_style_classes
  # def style_classes
  #   "#{ct_name} #{to_css_class(self.category)}"
  # end

  # def ct_name
  #   ct = category_type || ''
  #   return '' if ct =~ /unknown/i
  #   "type_#{ct.gsub(/[^a-z0-9\-_]+/i, '_')}"
  # end

  # def to_css_class ( cat, clss = nil )
  #   return clss if (clss = @@css_translation_cache[ cat ])
  #   @@css_translation_cache[ cat ] = css_class_search(cat) 
  # end

  # def css_class_search ( cat )
  #   @@Categories.each do |key, val|
  #     return ('cat_' + key) if val =~ cat
  #   end
  #   'cat_Unknown' 
  # end
  
    
#   @@css_translation_cache = {}

# #  @@Categories is a hash of keys
# #  corresponding to the css style used for each show category.  Each
# #  entry is an array containing the name of that category in the
# #  language this file defines (it will not be translated separately),
# #  and a regular expression pattern used to match the category against
# #  those provided in the listings.
#   @@Categories = {
#     'Action'         =>  /\b(action|adven)/i,
#     'Adult'          =>  /\b(adult|erot)/i,
#     'Animals'        =>  /\b(animal|tiere)/i,
#     'Art_Music'      =>  /\b(art|dance|music|cultur)/i,
#     'Business'       =>  /\b(biz|busine)/i,
#     'Children'       =>  /\b(child|infan|animation)/i,
#     'Comedy'         =>  /\b(comed|entertain|sitcom)/i,
#     'Crime_Mystery'  =>  /\b(crim|myster)/i,
#     'Documentary'    =>  /\b(doc)/i,
#     'Drama'          =>  /\b(drama)/i,
#     'Educational'    =>  /\b(edu|interests)/i,
#     'Food'           =>  /\b(food|cook|drink)/i,
#     'Game'           =>  /\b(game)/i,
#     'Health_Medical' =>  /\b(health|medic)/i,
#     'History'        =>  /\b(hist)/i,
#     'Horror'         =>  /\b(horror)/i,
#     'HowTo'          =>  /\b(how|home|house|garden)/i,
#     'Misc'           =>  /\b(special|variety|info|collect)/i,
#     'News'           =>  /\b(news|current)/i,
#     'Reality'        =>  /\b(reality)/i,
#     'Romance'        =>  /\b(romance)/i,
#     'SciFi_Fantasy'  =>  /\b(fantasy|sci\\w*\\W*fi)/i,
#     'Science_Nature' =>  /\b(science|nature|environm)/i,
#     'Shopping'       =>  /\b(shop)/i,
#     'Soaps'          =>  /\b(soaps)/i,
#     'Spiritual'      =>  /\b(spirit|relig)/i,
#     'Sports'         =>  /\b(sport)/i,
#     'Talk'           =>  /\b(talk)/i,
#     'Travel'         =>  /\b(travel)/i,
#     'War'            =>  /\b(war)/i,
#     'Western'        =>  /\b(west)/i
#   }

end
