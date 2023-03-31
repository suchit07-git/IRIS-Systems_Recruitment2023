FROM ruby:3.0.5
RUN apt-get update && apt-get install -y default-mysql-client
RUN mkdir /rails-app
WORKDIR /rails-app
COPY ./src/ /rails-app 
RUN bundle install
#EXPOSE 3000
CMD ["bundle", "exec"]
