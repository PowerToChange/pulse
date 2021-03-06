class Email < ActiveRecord::Base
  load_mappings
  belongs_to :sender, :class_name => "Person", :foreign_key => "sender_id"
  belongs_to :search, :class_name => "Search", :foreign_key => "search_id"
  validates_presence_of :subject, :body, :sender_id
  
  after_create :queue_email
  
  
  def send_email
    missing = []
    errors = {}
    if search
      ids = ActiveRecord::Base.connection.select_values("SELECT distinct(Person.#{_(:id, :person)}) FROM #{Person.table_name} as Person #{search.table_clause} WHERE #{search.query}")
      @people = Person.find(ids)
    else
      @people = Person.find(JSON::Parser.new(people_ids).parse)
    end
    @people.each do |person|
      if person.primary_email.present?
        begin
          Mailers::EmailMailer.deliver_email(person, self)
        rescue Net::SMTPFatalError => e
          errors[person.primary_email] = e.message
        end
      else
        missing << person
      end
    end
    begin
      Mailers::EmailMailer.deliver_report(self, missing, errors)
    rescue Net::SMTPFatalError => e
      logger.info "Could not send confirmation email to #{sender.primary_email}: #{e.message}"
      logger.flush
    end
    self.missing_address_ids = missing.collect(&:id).to_json
  end

  def render_body(person)
    Liquid::Template.parse(body).render 'first_name' => person.try(:first_name), 'last_name' => person.try(:last_name)
  end

  private
  def queue_email
    self.send_later(:send_email)
  end

end
