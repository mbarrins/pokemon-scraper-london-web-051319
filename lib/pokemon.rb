class Pokemon
  attr_accessor :id, :name, :type, :db, :hp

  def initialize(id:, name:, type:, db:, hp: 60)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = hp
  end

  def Pokemon.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?);
    SQL

    db.execute(sql, name, type)
    Pokemon.find(db.execute("SELECT last_insert_rowid() FROM pokemon;").first[0], db)
  end

  def self.find(id, db)
    sql = <<-SQL
      SELECT *
      FROM Pokemon
      WHERE id = ?
    SQL
    pokemon = db.execute(sql, id).first
    Pokemon.new(id: pokemon[0], name: pokemon[1], type: pokemon[2], hp: pokemon[3], db: db)
  end

  def alter_hp(hp, db)
    @hp = hp
    sql = <<-SQL
      UPDATE pokemon
      SET hp = ?
      WHERE id = ?;
    SQL

    db.execute(sql, hp, self.id)
  end
end
