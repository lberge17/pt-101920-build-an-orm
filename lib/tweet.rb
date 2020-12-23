class Tweet
    attr_accessor :content, :author
    attr_reader :id

    def initialize(attributes={})
        @id = attributes["id"]
        @content = attributes["content"]
        @author = attributes["author"]
    end

    def self.create_table
        sql = <<-SQL
            CREATE TABLE IF NOT EXISTS tweets (
                id INTEGER PRIMARY KEY,
                content TEXT,
                author TEXT
            );
        SQL

        DB[:conn].execute(sql)
    end

    def save
        if self.class.find(@id)
            sql <<-SQL
                UPDATE tweets
                SET content = ?, author = ?
                WHERE id = ?;
            SQL

            DB[:conn].execute(sql, @content, @author, @id)
        else
            sql = <<-SQL
                INSERT INTO tweets (content, author) 
                VALUES (?, ?);
            SQL

            DB[:conn].execute(sql, @content, @author)
            @id = DB[:conn].last_insert_row_id
        end
        self
    end

    def self.find(id)
        sql = <<-SQL
            SELECT * FROM tweets WHERE id = ?;
        SQL

        Tweet.new(DB[:conn].execute(sql, id)[0])
    end

    def self.all
        tweets = DB[:conn].execute("SELECT * FROM tweets;")
        tweets.map do |attributes|
            Tweet.new(attributes)
        end
    end

    def self.create(attributes)
        new(attributes).save
    end
end