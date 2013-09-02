

class Genre < ActiveRecord::Base

  self.table_name = 'genre'

  belongs_to :program, foreign_key: 'program'

end
