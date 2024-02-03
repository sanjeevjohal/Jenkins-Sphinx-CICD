pipeline {
    agent any

    stages {
        stage('Validate YAML') {
            steps {
                script {
                    // Read the YAML file
                    def yaml = readYaml file: 'projects/aws_tags/cfn.yaml'

                    // Define the required tags
                    def requiredTags = ['service', 'criticalsystem', 'publiclyaccessible', 'creator', 'maintainer']

                    // Check if the required tags are present
                    requiredTags.each { tag ->
                        if (!yaml.stacks.test_bucket.tags.containsKey(tag)) {
                            error("Missing tag: ${tag}")
                        }
                    }
                }
            }
        }
    }
}