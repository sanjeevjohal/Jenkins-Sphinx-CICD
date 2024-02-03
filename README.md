# Links
- see this [YT](https://www.youtube.com/watch?v=jSm0YZ-NQAc)
- see this local Pycharm project readme [link]
  (/Users/sjohal/OneDrive/PycharmProjects/cafeday/Jenkins-docker-local/README.md) to see how to 
  install a local instance of Jenkins
- [Getting started Jenkins docs](https://www.jenkins.io/pipeline/getting-started-pipelines/)
- [Jenkins User handbook](https://www.jenkins.io/doc/book/pipeline/getting-started/)
- [ngrok webhooks](https://ngrok.com/docs/integrations/github/webhooks/)
- [ngrok webhooks troublshooting](https://docs.github.com/en/webhooks/testing-and-troubleshooting-webhooks/testing-webhooks)

# Setup
## Configure Github integration

1. Add these plugins
   2. Ensure this plugin [link](https://plugins.jenkins.io/github/) is enabled - should have been installed as part of the recommended plugins)
   3. `SSH Agent Plugin` - _This plugin allows you to provide SSH credentials to builds via a ssh-agent in Jenkins_
2. Go to `Manage Jenkins` > `Configure System` > `GitHub` > `Add GitHub Server`
3. Add your credentials - see password repositories for secret token...and **test** (NB. what access 
   was granted when the token was created, so if `public_repo` was granted then ensure the repo is 
   **public**)
4. Could let jenkins manage the hook which will create a webhook in the repository but to do manually
   5. Generate a ssh key pair
   6. Add the public key to the repository
   7. Add the private key to Jenkins `Manage Jenkins` > `Manage Credentials` > `Jenkins` > `Global 
      credentials` and **test**
8. Create a new pipeline job:
   9. `New Item` > `Freestyle project`
   10. Then add `ssh` link to the repository and use the ppk credentials created earlier
   12. Add build triggers e.g. `push` only
   13. Set `post-build` actions as follows:
       14. Set GitHub commit status (universal) - _Using GitHub status api sets status of the commit._
       15. Where :: Commit SHA: Latest build revision 
       16. Repositories :: Any defined in job repository 
       17. What :: Commit context: From GitHub property with fallback to job name 
       18. Status result :: One of default messages and statuses 
       19. Status backref :: Backref to the build
       
...._this will_ 
       - use the latest Commit SHA that triggered the Jenkins build. 
       - label with the commit context otherwise fallback to the Jenkins job name 
       - set the status on the commit which will show up as a tick and backref to the Jenkins build
9. The _manually_ add the webhook to Jenkins (NB. can't use `localhost` nor public ip address because 
   this isn't reachable over the internet), so use a service like `ngrok` to create a secure 
   tunneling service to this local host and provide a _temporary_ public url that GitHub can send 
   webhook payloads to. It does this by assigning a temporary public domain to the local host and 
   then forwards the traffic to the local host and bypasses any firewall or NAT (network address 
   translation - which is used to map multiple private ip addresses to a single public ip address 
   which is usually the home router).
10. Install `ngrok` and run it
```shell
brew install ngrok
```
11. Add the authtoken to the local ngrok.yaml file
```shell
ngrok config add-authtoken 2blvBeMfE61fK2UwYMJmvhEGb7p_764LFA4eAsyMNTSbfz6KG
```
12. Run `ngrok` and expose the local host to the internet
```shell
ngrok http 8080
```
13. Use the `forwarding` || "/github-webhook/" url to add the webhook to the repository and disable 
    the SSL and **test ie deliver payload & commit code**

## Troublshooting
1. Use `http://127.0.0.1:4040/inspect/http` to see the requests and responses

---
# Projects
## Auto-generate Sphinx documentation
1. Jenkins pipeline features (written in Groovy DSL - Domain Specific Language)
   2. Install Dependencies
      3. Agent directive to specify where the pipeline will run i.e. `docker` container
      4. Environment directive to specify the global environment variables
   3. Build
      4. Stage directive is the payload with a series of steps where we first create a `venv` 
      5. Re-build sphinx documentation
   4. Deploy
      5. Deploy documentation using rsync

### Links
- [CI using docker](https://www.jareddillard.com/blog/continuous-deployment-of-a-sphinx-website-with-using-jenkins-and-docker.html)
  - [Live demo](https://github.com/jdillard/continuous-sphinx)
  - [Jdillard Sphinx Links](https://github.com/jdillard?tab=repositories&q=sphinx&type=&language=&sort=)
- [Jenkins HTML Publisher Plugin](https://plugins.jenkins.io/htmlpublisher/)

### Sphinx Objectives
- [ ] Make my own
- [ ] Create a Jenkins pipeline to auto-generate Sphinx documentation
- [ ] Add link to Apache Airflow project as a plugin
- [ ] add callgraph using pyan3 (nb. add to requirements.txt)
- [ ] add as a webhook to the repository
---

### Quick Demo for CafeDay
1. Start a local Jenkins instance
```shell
brew services start jenkins-lts
```
2. Add another module to `foo` with docstrings
3. Include this in `index.rst`
4. Start `ngrok` and add the webhook to the **GITHUB** repository and **test**
5. Push the code to the repository and see the Jenkins build
5. Start a local server to see the documentation
```shell
cd _built
python3 -m http.server 8081
```

---

### Sphinx Troubleshooting
1. Test locally
```shell
export SPHINX_DIR='.'
export BUILD_DIR='./_built'
export SOURCE_DIR='./source'
export DEPLOY_HOST='/tmp/sj_docs/'

sphinx-build \
-q -w ${SPHINX_DIR}/sphinx-build.log \
-b html \
-d ${BUILD_DIR}/doctrees ${SOURCE_DIR} ${BUILD_DIR}

# add '_built', sphinx-build.log & source/modules to .gitignore
cat << EOF >> .gitignore
_built
sphinx-build.log
source/modules
EOF

cd $(BUILD_DIR)
python3 -m http.server 8081
```

# Overall Objectives
- [ ] improve pipeline readability e.g. use stages, add comments, make stages more modular & descriptive
**- [ ] Snapshot local Jenkins instance**
- [ ] tidy-up this readme.md
  - move out troubleshooting to a separate file
  - create separate readme.md for each project

---

## Validate AWS tags

## Test out liquibase-runner

---
# Troubleshoot
1. If you get `docker command not found` then add this to the plist file: `homebrew.mxcl.jenkins-lts 
   copy.plist` which can be found by `brew info jenkins-lts` and then `brew services restart jenkins-lts`
```xml
<key>EnvironmentVariables</key>
<dict>
    <key>PATH</key>
    <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin/docker</string>
</dict>
```

