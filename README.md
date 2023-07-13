
#### Graphql API with Multi-Factor Authentication

- Find an API User
- Find all API Users
- Revoke an API Key


#### Create Application
```
rails new graphql-api-mfa --database sqlite3 --skip-action-mailbox --skip-action-text --skip-spring --webpack=react -T

cd graphql-api-mfa

bundle add graphql

rails generate graphql:install
```

#### Add Gems

```ruby
gem 'bcrypt', "~> 3.1.7"

group :development, :test do
  ...
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-theme'
  gem 'rubocop', require: false
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
id  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
  gem 'database_cleaner-active_record', require: false
end
```


Paste the below into `.pryrc`:
```
# using a pry theme
#
# Copy this file to .prycr
#
# To use a different theme, in the rails console:
#   > pry-theme try ocean
#   > pry-theme install ocean

Pry.config.theme = 'vividchalk'
#Pry.config.theme = 'tomorrow-night'
#Pry.config.theme = 'ocean'
```



#### Queries
In the GraphQL Playground: http://127.0.0.1:3003/graphiql

Use HTTP Headers
```
{
  "Authorization": "Bearer cbe9748c3c7889b0d37a9c9ca0d83685"
}
```

#### Find API User by ID
```
{
  apiUser(id: 1) {
    id
    email
  } 
}
```

```
{
  apiUser(id: 1) {
    id
    email
    createdAt
    updatedAt
    apiKeys {
      bearer {
        id
        email
      }
      token
    }
  }
}
```

#### Find all API Users
```
{
  apiUsers {
    id
    email
    createdAt
  }
}
```

```
{
  apiUsers {
    id
    email
    createdAt
    apiKeys {
      bearer {
        id
        email
      }
      token
    }
  }
}
```

#### Mutations

In the GraphQL Playground: http://127.0.0.1:3003/graphiql

Use HTTP Headers
```
{
  "Authorization": "Bearer cbe9748c3c7889b0d37a9c9ca0d83685"
}
```


#### Revoke an API Key

```
mutation {
  revokeApiKey(input: { params: { email: "foo@manchoo.com" } }) {
    apiKey {
      token
      status
    }
  }
}
```


#### Verify / Authenticate User

Supported auth methods:
- password
- one time password (otp)
- time-based one time password (totp) - UNDER DEVELOPMENT

```
mutation {
  verifyUser(input: { params: { email: "foo@manchoo.com", password: "topsecret" otp: "yeehaw"} }) {
    authenticate {
      id
      email
    }
  }
}

```


#### Resources

- [https://www.apollographql.com/blog/community/backend/using-graphql-with-ruby-on-rails/)(https://www.apollographql.com/blog/community/backend/using-graphql-with-ruby-on-rails/)
- [https://graphql-ruby.org/](https://graphql-ruby.org/)
- [https://www.honeybadger.io/blog/graphql-apis-for-rails/](https://www.honeybadger.io/blog/graphql-apis-for-rails/)
- [https://www.digitalocean.com/community/tutorials/how-to-set-up-a-ruby-on-rails-graphql-api](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-ruby-on-rails-graphql-api)


#### GraphQL / REST Pros & Cons


- REST Pros
  - accept diverse data formats (ex: json, xml)
  - scalability

- REST Cons
  - over-fetching
  - under-fetching
  - versioning


- GraphQL Pros
  - no over / under fetching
  - one end-point
  - strong typing
  - no versioning

- GraphQL Cons
  - complexity / learning curve
  - performance issues; abused nested attributes; n+1 queries
  - file uploading not supported
  - status 200 for every request


