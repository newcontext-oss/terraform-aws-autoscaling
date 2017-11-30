# Auto Scaling Group with Launch Configuration for testing

Configuration in this directory creates Launch Configuration and Auto Scaling
Group for testing with kitchen-terraform.

# Usage

1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in
   the
   [Gemfile](https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/master/Gemfile).
2. Install bundler and the gems from our Gemfile:

```
gem install bundler; bundle install
```

3. Ensure your AWS environment is configured (i.e. credentials and region) for
   test and set TF_VAR_region to a valid AWS region (e.g. `export
   TF_VAR_region=${AWS_REGION}`).
4. Test using `bundle exec kitchen test` from the root of the repo.
