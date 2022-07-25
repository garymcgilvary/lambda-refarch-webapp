// You can obtain these values by running:
// aws cloudformation describe-stacks --stack-name <YOUR STACK NAME> --query "Stacks[0].Outputs[]"

const config = {
  "aws_user_pools_web_client_id": "2ndrbtf3j6gm9kvb8gnkdejc4q",     // CognitoClientID
  "api_base_url": "https://htundwfph3.execute-api.eu-west-2.amazonaws.com/prod",                                     // TodoFunctionApi
  "cognito_hosted_domain": "mytodoappdemo-test-app.auth.eu-west-2.amazoncognito.com",                   // CognitoDomainName
  "redirect_url": "https://master.d14h9twexw5mrc.amplifyapp.com"                                      // AmplifyURL
};

export default config;
