require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
	include Singleton

	def initialize
		super('questions.db')
		self.type_translation = true
		self.results_as_hash = true
	end
end


#####################


class Question
	attr_accessor :id, :title, :body, :user_id

	def self.find_by_id(id)
		data = QuestionsDatabase.instance.execute("SELECT * FROM questions WHERE id = '#{id}'")
		data.map { |datum| Question.new(datum)}
	end

	def self.find_by_author_id(author_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
			SELECT 
				*
			FROM
				questions
			WHERE
				user_id = ?
		SQL

		data.map { |datum| Question.new(datum)}
	end


	def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
	end
	
	def create
		raise "#{self} already in database" if self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.user_id)
			INSERT INTO
				questions (title, body, user_id)
			VALUES
				(?, ?, ?)
		SQL
		self.id = QuestionsDatabase.instance.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.title, self.body, self.user_id)
			UPDATE
				questions
			SET
				title = ?, body = ?, user_id = ?
			WHERE
				id = ?
		SQL
	end
end

#####################


class User
	attr_accessor :id, :fname, :lname

	def self.find_by_name(fname, lname)
		data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
			SELECT 
				*
			FROM
				users
			WHERE
				fname = ? AND
				lname = ?
		SQL
		data.map { |datum| User.new(datum)}
	end

	def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
	end
	
	def create
		raise "#{self} already in database" if self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
			INSERT INTO
				users (fname, lname)
			VALUES
				(?, ?)
		SQL
		self.id = QuestionsDatabase.instance.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.fname, self.lname)
			UPDATE
				users
			SET
				fname = ?, lname = ?
			WHERE
				id = ?
		SQL
	end
end


#####################


class QuestionFollow
	attr_accessor :id, :question_id, :user_id

	def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
	end
	
	def create
		raise "#{self} already in database" if self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
			INSERT INTO
				question_follows (question_id, user_id)
			VALUES
				(?, ?)
		SQL
		self.id = QuestionsDatabase.instance.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
			UPDATE
				question_follows
			SET
				question_id = ?, user_id = ?
			WHERE
				id = ?
		SQL
	end
end

#####################


class QuestionLikes
	attr_accessor :id, :question_id, :user_id

	def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
	end
	
	def create
		raise "#{self} already in database" if self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
			INSERT INTO
				question_likes (question_id, user_id)
			VALUES
				(?, ?)
		SQL
		self.id = QuestionsDatabase.instance.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.user_id)
			UPDATE
				question_likes
			SET
				question_id = ?, user_id = ?
			WHERE
				id = ?
		SQL
	end
end

#####################


class Reply
	attr_accessor :id, :question_id, :parent_id, :user_id, :body

	def self.find_by_user_id(user_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
			SELECT 
				*
			FROM
				replies
			WHERE
				user_id = ?
		SQL
		
		data.map { |datum| Reply.new(datum)}
	end

	def self.find_by_question_id(question_id)
		data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
			SELECT 
				*
			FROM
				questions
			WHERE
				question_id = ?
		SQL
		
		data.map { |datum| User.new(datum)}
	end

	def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
	end
	
	def create
		raise "#{self} already in database" if self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.parent_id, self.user_id, self.body)
			INSERT INTO
				replies (question_id, parent_id, user_id, body)
			VALUES
				(?, ?, ?, ?)
		SQL
		self.id = QuestionsDatabase.instance.last_insert_row_id
	end

	def update
		raise "#{self} not in database" unless self.id
		QuestionsDatabase.instance.execute(<<-SQL, self.question_id, self.parent_id, self.user_id, self.body)
			UPDATE
				replies
			SET
				question_id = ?, parent_id = ?, user_id = ?, body = ?
			WHERE
				id = ?
		SQL
	end
end