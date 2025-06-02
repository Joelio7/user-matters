# Legal Matter Management API

A Ruby on Rails 8 API application for managing legal matters locally. Built with JWT authentication, role-based authorization, and comprehensive testing.

## 🚀 Features

- **JWT Authentication** - Secure token-based authentication
- **Role-based Authorization** - Using Pundit for fine-grained permissions
- **Matter Management** - Create, update, and track legal matters
- **User Management** - Multi-tenant user system with firm support
- **RESTful API** - JSON API endpoints
- **Comprehensive Testing** - RSpec test suite

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby** 3.3.0+ (check with `ruby --version`)
- **Rails** 8.0.2+ (check with `rails --version`)
- **PostgreSQL** 14+ (check with `psql --version`)
- **Git** (check with `git --version`)

### Installing Prerequisites

#### macOS (using Homebrew)
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install ruby postgresql git
```

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install ruby-full postgresql postgresql-contrib git
```

#### Windows
Use WSL2 with Ubuntu or install using RubyInstaller and PostgreSQL installer from their respective websites.

## 🛠 Installation

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd legal-matter-api
```

### 2. Install Ruby Dependencies
```bash
# Install bundler if not already installed
gem install bundler

# Install gems
bundle install
```

### 3. Database Setup

#### Start PostgreSQL
```bash
# macOS (Homebrew):
brew services start postgresql

# Ubuntu/Debian:
sudo systemctl start postgresql

# Create a PostgreSQL user (if needed)
createuser -s your_username
```

#### Create Local Database Configuration
The app is set up to work with default PostgreSQL settings. If you need custom settings, create `config/database.yml`:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5

development:
  <<: *default
  database: legal_matter_api_development

test:
  <<: *default
  database: legal_matter_api_test
```

### 4. Environment Variables (Optional)

For local development, create a `.env` file if you need custom settings:

```bash
# Only needed if you have non-default PostgreSQL settings
# DATABASE_USERNAME=your_username
# DATABASE_PASSWORD=your_password

# JWT secret (will auto-generate if not set)
# JWT_SECRET_KEY=your_local_secret_key
```

### 5. Database Setup
```bash
# Create databases
rails db:create

# Run migrations
rails db:migrate

# Seed the database (optional)
rails db:seed
```

### 6. Start the Server
```bash
rails server

# Visit http://localhost:3000
# You should see a Rails welcome page or API response
```

## 🏃‍♂️ Running the Application

### Development Mode
```bash
# Start the Rails server
rails server
# or
rails s

# Server will start on http://localhost:3000
```

### Stop the Server
Press `Ctrl+C` in the terminal where the server is running.

## 🧪 Testing

This application uses RSpec for testing with FactoryBot and Shoulda Matchers.

### Running Tests

#### Run All Tests
```bash
# Run the entire test suite
bundle exec rspec

# Run with detailed output
bundle exec rspec --format documentation
```

#### Run Specific Tests
```bash
# Run only model tests
bundle exec rspec spec/models

# Run only API tests  
bundle exec rspec spec/requests

# Run a specific file
bundle exec rspec spec/models/matter_spec.rb

# Run a specific test (by line number)
bundle exec rspec spec/models/matter_spec.rb:15
```

### Test Database Issues?
```bash
# Reset test database if needed
RAILS_ENV=test rails db:reset
```

## 📚 API Usage

### Base URL
```
http://localhost:3000/api
```

### Quick API Test

Start your server (`rails s`) and test with curl:

#### Register a User
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com", 
    "firm_name": "Doe Law Firm",
    "phone": "+1-555-123-4567",
    "password": "password123",
    "password_confirmation": "password123"
  }'
```

#### Login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

#### Use the Token from Login Response
```bash
# Get matters (replace YOUR_TOKEN with actual token)
curl -X GET http://localhost:3000/api/matters \
  -H "Authorization: Bearer YOUR_TOKEN"

# Create a matter
curl -X POST http://localhost:3000/api/matters \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Contract Review",
    "description": "Review employment contract", 
    "state": "new",
    "due_date": "2024-12-31"
  }'
```

## 🛠 Development Tools

### Rails Console
```bash
# Access Rails console to interact with your data
rails console
# or
rails c

# Example usage in console:
# User.all
# Matter.create(title: "Test Matter", state: "new", user: User.first)
```

### Database Console
```bash
# Access PostgreSQL directly
rails dbconsole
# or
rails db

# Example SQL:
# SELECT * FROM users;
# SELECT * FROM matters;
```

### Code Quality
```bash
# Check code style
bundle exec rubocop

# Auto-fix style issues
bundle exec rubocop -a

# Security analysis
bundle exec brakeman
```

### Database Operations
```bash
# Create a new migration
rails generate migration AddFieldToModel field:type

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Check migration status
rails db:migrate:status

# Reset database (⚠️ deletes all data)
rails db:reset
```

## 🐛 Troubleshooting

### Server Won't Start
```bash
# Check if something is using port 3000
lsof -i :3000

# Kill process on port 3000 if needed
kill -9 $(lsof -ti:3000)

# Start on different port
rails server -p 3001
```

### Database Issues
```bash
# Check if PostgreSQL is running
pg_isready

# Restart PostgreSQL
# macOS:
brew services restart postgresql

# Ubuntu:
sudo systemctl restart postgresql

# Recreate databases if corrupted
rails db:drop db:create db:migrate
```


### Common Error Messages

**"Could not connect to server"**
- PostgreSQL isn't running. Start it with the commands above.

**"database does not exist"**
- Run `rails db:create`

**"PendingMigrationError"**
- Run `rails db:migrate`

**"Validation failed" in tests**
- Check your factories in `spec/factories/` have all required fields

## 📁 Project Structure

```
legal-matter-api/
├── app/
│   ├── controllers/api/        # API controllers
│   ├── models/                 # Data models
│   ├── policies/              # Pundit authorization policies
│   └── serializers/           # JSON serializers
├── config/                    # App configuration
├── db/
│   ├── migrate/              # Database migrations
│   └── seeds.rb              # Seed data
├── spec/
│   ├── factories/            # Test data factories
│   ├── models/               # Model tests
│   ├── requests/             # API tests
│   └── support/              # Test helpers
└── README.md                 # This file
```

## 🎯 Next Steps

1. **Start the server**: `rails server`
2. **Run tests**: `bundle exec rspec`
3. **Open Rails console**: `rails console`
4. **Test API endpoints** with curl or Postman

Need help? Check the Rails console for errors or create an issue in this repository!