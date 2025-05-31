puts "Clearing existing data..."
Matter.destroy_all
User.destroy_all

puts "Creating seed data..."

admin_names = [
  { name: "Sarah Johnson", email: "sarah.admin@usermatters.com", firm: "User Matters Legal" },
  { name: "Michael Chen", email: "michael.admin@usermatters.com", firm: "User Matters Legal" },
  { name: "Elena Rodriguez", email: "elena.admin@usermatters.com", firm: "User Matters Legal" }
]

admins = []
admin_names.each do |admin_data|
  admin = User.create!(
    name: admin_data[:name],
    email: admin_data[:email],
    password: "admin123456",
    firm_name: admin_data[:firm],
    role: "admin"
  )
  admins << admin
  puts "Created admin: #{admin.email}"
end

customer_names = [
  { name: "John Smith", email: "john.smith@acmecorp.com", firm: "Acme Corporation" },
  { name: "Emily Davis", email: "emily.davis@techstart.io", firm: "TechStart Solutions" },
  { name: "Robert Wilson", email: "robert.wilson@greenfield.org", firm: "Greenfield Industries" },
  { name: "Maria Garcia", email: "maria.garcia@globaltech.com", firm: "GlobalTech Inc" },
  { name: "David Brown", email: "david.brown@innovate.co", firm: "Innovate Co" },
  { name: "Jennifer Lee", email: "jennifer.lee@brightfuture.net", firm: "Bright Future LLC" },
  { name: "Christopher Taylor", email: "chris.taylor@nexusgroup.com", firm: "Nexus Group" },
  { name: "Amanda White", email: "amanda.white@peakperform.biz", firm: "Peak Performance Ltd" },
  { name: "Ryan Martinez", email: "ryan.martinez@stellardesign.com", firm: "Stellar Design Studio" },
  { name: "Lisa Thompson", email: "lisa.thompson@dynamicventures.com", firm: "Dynamic Ventures" }
]

customers = []
customer_names.each do |customer_data|
  customer = User.create!(
    name: customer_data[:name],
    email: customer_data[:email],
    password: "customer123",
    firm_name: customer_data[:firm],
    role: "customer"
  )
  customers << customer
  puts "Created customer: #{customer.email}"
end

matter_templates = [
  {
    title: "Contract Review - Service Agreement",
    description: "Need legal review of our new service provider agreement before signing. Contains clauses about liability and data protection."
  },
  {
    title: "Employment Policy Update",
    description: "Updating our employee handbook to comply with new state regulations. Need review of termination and benefits sections."
  },
  {
    title: "Intellectual Property Filing",
    description: "Filing trademark application for our new product line. Need assistance with research and application preparation."
  },
  {
    title: "Lease Agreement Negotiation",
    description: "Negotiating terms for new office space lease. Landlord proposing significant changes to standard terms."
  },
  {
    title: "Partnership Agreement Draft",
    description: "Creating partnership agreement for joint venture with overseas company. Need to address profit sharing and dispute resolution."
  },
  {
    title: "Compliance Audit Preparation",
    description: "Preparing for upcoming regulatory compliance audit. Need review of our current policies and procedures."
  },
  {
    title: "Non-Disclosure Agreement",
    description: "Standard NDA template review for new vendor relationships. Need to ensure adequate protection of trade secrets."
  },
  {
    title: "Merger Documentation",
    description: "Legal support needed for potential acquisition. Due diligence and contract preparation required."
  },
  {
    title: "Employment Contract Dispute",
    description: "Former employee claiming breach of contract. Need legal assessment and response strategy."
  },
  {
    title: "Privacy Policy Update",
    description: "Updating privacy policy to comply with new data protection regulations. Need comprehensive legal review."
  },
  {
    title: "Vendor Agreement Termination",
    description: "Terminating underperforming vendor contract. Need to ensure proper notice and minimize legal exposure."
  },
  {
    title: "Corporate Governance Review",
    description: "Annual review of corporate bylaws and governance procedures. Board requesting comprehensive compliance check."
  },
  {
    title: "Licensing Agreement",
    description: "Negotiating software licensing agreement with technology partner. Complex terms around usage rights and restrictions."
  },
  {
    title: "Insurance Claim Legal Support",
    description: "Insurance company disputing coverage for recent incident. Need legal representation for claim negotiation."
  },
  {
    title: "Shareholder Agreement Update",
    description: "Updating shareholder agreement due to new investment round. Need to address dilution and voting rights."
  },
  {
    title: "Customer Contract Dispute",
    description: "Client refusing payment claiming breach of service terms. Need legal analysis and collection strategy."
  },
  {
    title: "Regulatory Compliance Filing",
    description: "Annual regulatory filing deadline approaching. Need legal review of submissions and supporting documentation."
  },
  {
    title: "Real Estate Purchase Legal Review",
    description: "Purchasing new facility for operations. Need comprehensive legal review of purchase agreement and title."
  },
  {
    title: "Employment Termination Legal Review",
    description: "Terminating executive employee. Need to ensure proper procedure and minimize wrongful termination risk."
  },
  {
    title: "International Trade Documentation",
    description: "Expanding into new international markets. Need legal review of export/import documentation and compliance requirements."
  }
]

states = ['new', 'in_progress', 'completed']

20.times do |i|
  customer = customers.sample
  
  matter_template = matter_templates[i % matter_templates.length]
  
  due_date = rand(-1.week..8.weeks).seconds.from_now
  
  state = states.sample
  
  matter = Matter.create!(
    title: matter_template[:title],
    description: matter_template[:description],
    state: state,
    due_date: due_date,
    user: customer
  )
  
  puts "Created matter: '#{matter.title}' for #{customer.name} (#{state})"
end

puts "\n=== Seed Summary ==="
puts "Admins created: #{User.admin.count}"
puts "Customers created: #{User.customer.count}"
puts "Total matters created: #{Matter.count}"
puts "  - New matters: #{Matter.pending.count}"
puts "  - In progress matters: #{Matter.in_progress.count}"
puts "  - Completed matters: #{Matter.completed.count}"

puts "\n=== Admin Login Credentials ==="
User.admin.each do |admin|
  puts "#{admin.email} / admin123456"
end

puts "\n=== Sample Customer Login Credentials ==="
User.customer.limit(3).each do |customer|
  puts "#{customer.email} / customer123"
end

puts "\nSeeding completed!"