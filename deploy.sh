set -x


export STACK_NAME='test-app'
export AWS_DEFAULT_REGION=eu-west-2 

sam build --use-container
sam deploy --guided --stack-name $STACK_NAME --profile dev

export AWS_COGNITO_REGION=$AWS_DEFAULT_REGION
export AWS_USER_POOLS_WEB_CLIENT_ID=`aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='CognitoClientID'].OutputValue" --output text --profile dev` 
export API_BASE_URL=`aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='TodoFunctionApi'].OutputValue" --output text --profile dev`
export STAGE_NAME_PARAM=`aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Parameters[?ParameterKey=='StageNameParam'].ParameterValue" --output text --profile dev`
export COGNITO_HOSTED_DOMAIN=`aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='CognitoDomainName'].OutputValue" --output text --profile dev`
export REDIRECT_URL=`aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='AmplifyURL'].OutputValue" --output text --profile dev`

cp www/src/config.default.js www/src/config.js
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e 's/AWS_USER_POOLS_WEB_CLIENT_ID/'"$AWS_USER_POOLS_WEB_CLIENT_ID"'/g' www/src/config.js
  sed -i '' -e 's/API_BASE_URL/'"${API_BASE_URL//\//\\/}"'/g' www/src/config.js
  sed -i '' -e 's/{StageNameParam}/'"$STAGE_NAME_PARAM"'/g' www/src/config.js
  sed -i '' -e 's/COGNITO_HOSTED_DOMAIN/'"$COGNITO_HOSTED_DOMAIN"'/g' www/src/config.js
  sed -i '' -e 's/REDIRECT_URL/'"${REDIRECT_URL//\//\\/}"'/g' www/src/config.js
else
  sed -i -e 's/AWS_USER_POOLS_WEB_CLIENT_ID/'"$AWS_USER_POOLS_WEB_CLIENT_ID"'/g' www/src/config.js
  sed -i -e 's/API_BASE_URL/'"${API_BASE_URL//\//\\/}"'/g' www/src/config.js
  sed -i -e 's/{StageNameParam}/'"$STAGE_NAME_PARAM"'/g' www/src/config.js
  sed -i -e 's/COGNITO_HOSTED_DOMAIN/'"$COGNITO_HOSTED_DOMAIN"'/g' www/src/config.js
  sed -i -e 's/REDIRECT_URL/'"${REDIRECT_URL//\//\\/}"'/g' www/src/config.js
fi

git add www/src/config.js
git commit -m 'Frontend config update'
git push
