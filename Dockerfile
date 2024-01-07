From ubuntu
run apt-get update -y
run apt-get upgrade -y
run apt-get install default-jre -y
run mkdir shivani
workdir shivani
copy helloworld.java .
cmd ["java","helloworld.java"] 



