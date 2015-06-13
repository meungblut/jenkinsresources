ssh-keygen.exe -t rsa -C "meungblute@github.com" -f id_rsa_git -P """"

printf '{"title":"machine-key2","key":"' > post.txt
cat id_rsa_git.pub >> post.txt
printf '"}' >> post.txt

cat CredentialsTop.txt id_rsa_git CredentialsTail.txt > /c/Progra~2/jenkins/credentials.xml 

curl -u "soaspike:soaspike1" --data @post.txt https://api.github.com/user/keys -k
ssh-keyscan github.com > ~/.ssh/known_hosts

/c/Progra~2/jenkins/jre/bin/java -jar /c/Progra~2/jenkins/war/web-inf/jenkins-cli.jar -s http://localhost:8080 create-job Build < jenkinsbuild.xml

/c/Progra~2/jenkins/jre/bin/java -jar /c/Progra~2/jenkins/war/web-inf/jenkins-cli.jar -s http://localhost:8080 safe-restart