# infrastructure-as-code
IAC project for running and monitoring nodejs application


Issues you might face
1. For the initial setup comment "dynamodb_table          = "terrafotrm-state-lock" " in state.tf as the dynamodb doesnt exist it will fail to aquire lock.
