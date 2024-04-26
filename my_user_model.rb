require 'sqlite3'
class User
  def initialize
    @db = SQLite3::Database.new 'db.sql'
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstname VARCHAR(50),
        lastname VARCHAR(50),
        age INTEGER,
        password VARCHAR(50),
        email VARCHAR(50)
      );
    SQL
  end

  def create(user_info)
    @db.execute("INSERT INTO users (firstname, lastname, age, password, email) VALUES (?, ?, ?, ?, ?)",
                user_info[:firstname], user_info[:lastname], user_info[:age], user_info[:password], user_info[:email])
    @db.last_insert_row_id
  end

  def find(user_id)
    @db.execute("SELECT * FROM users WHERE id = ?", user_id).first
  end

  def all
    users = {}
    @db.execute("SELECT id, firstname, lastname, age, email FROM users").each do |user|
      users[user[0]] = { firstname: user[1], lastname: user[2], age: user[3], email: user[4] }
    end
    users
  end

  def update(user_id, attribute, value)
    @db.execute("UPDATE users SET #{attribute} = ? WHERE id = ?", value, user_id)
    find(user_id)
  end

  def destroy(user_id)
    @db.execute("DELETE FROM users WHERE id = ?", user_id)
  end
end