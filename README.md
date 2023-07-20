
#### Graphql API with Multi-Factor Authentication

- [Using Bearer Token Authentication](#using-bearer-token-authentication)
- [Using Basic Authentication](#using-basic-authentication)
- [Queries](#queries)
  - [Find API User By ID](#find-api-user-by-id)
  - [Find all API Users](#find-all-api-users)
- [Mutations](#mutations)
  - [User Config Management](#user-config-management)
  - [Revoke an API Key](#revoke-an-api-key)
  - [Verify / Authenticate User](#verify--authenticate-user)
- [GraphQL / REST Pros & Cons](#graphql--rest-pros--cons)
- [Application Creation Notes](#application-creation-notes)
- [Development Resources](#development-resources)


#### Using Bearer Token Authentication

To get a users api key token.
```ruby
[1] pry(main)> User.find_by(email: 'foo@manchoo.com').api_keys.newest.token
=> "cdecfa98af8a366a760c34b0f1be6c13"
```

Set HTTP headers to use bearer token auth.
```
{
  "Authorization": "Bearer cbe9748c3c7889b0d37a9c9ca0d83685"
}
```

#### Using Basic Authentication

To Base64 encode a users email and password.
```ruby
[1] pry(main)> Base64.encode64('foo@manchoo.com:topsecret')
=> "Zm9vQG1hbmNob28uY29tOnRvcHNlY3JldA==\n"
```

Set HTTP headers to use basic auth.
```
{
  "Authorization": "Basic Zm9vQG1hbmNob28uY29tOnRvcHNlY3JldA==\n"
}
```


#### Queries
In the GraphQL Playground: http://127.0.0.1:3003/graphiql


#### Find API User By ID
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


#### User Config Management

Use this mutation to enable / disable user config fields.
```
mutation {
  userConfigAdmin(input: { params: { email: "foo@manchoo.com", otpEnabled: true } }) {
    attributes {
      otpEnabled
      user {
        email
      }
    }
  }
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

This mutation uses Basic Authentication.

```
mutation {
  verifyUser(input: { params: { otp: "woohoo" } }) {
    verified {
      id
      email
      apiKeys {
        token
      }
    }
  }
}
```


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


#### Application Creation Notes

Creating the rails application.
```
rails new graphql-api-mfa \
          --database sqlite3 \
          --skip-action-mailbox \
          --skip-action-text \
          --skip-spring \
          --webpack=react -T

cd graphql-api-mfa

bundle add graphql

rails generate graphql:install
```

Add gems to `Gemfile`.

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
  gem 'shoulda-matchers', '~> 5.0'
  gem 'simplecov', require: false
  gem 'database_cleaner-active_record', require: false
end
```

Add some flare for working in the rails console.

Paste the below into `.pryrc` in the application root directory.
```
# using a pry theme
#
# To use a different theme, in the rails console:
#   > pry-theme try ocean
#   > pry-theme install ocean

Pry.config.theme = 'vividchalk'
#Pry.config.theme = 'tomorrow-night'
#Pry.config.theme = 'ocean'
```


#### Development Resources

GraphQL

- [using-graphql-with-ruby-on-rails)(https://www.apollographql.com/blog/community/backend/using-graphql-with-ruby-on-rails/)
- [graphql-ruby.org](https://graphql-ruby.org/)
- [graphql-apis-for-rails](https://www.honeybadger.io/blog/graphql-apis-for-rails/)
- [how-to-set-up-a-ruby-on-rails-graphql-api](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-ruby-on-rails-graphql-api)

Other Tech Resources

- [how-to-implement-decorator-pattern-in-ruby-on-rails-7](https://dev.to/vladhilko/how-to-implement-decorator-pattern-in-ruby-on-rails-7ji)
