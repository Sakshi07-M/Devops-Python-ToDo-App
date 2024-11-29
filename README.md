# django-todo
A simple todo app built with django by
![todo App](https://raw.githubusercontent.com/shreys7/django-todo/develop/staticfiles/todoApp.png)

### Manaul Setup
To get this repository, run the following command inside your git enabled terminal
```bash
$ git clone https://github.com/Sakshi07-M/Devops-Python-Todo-App.git
```
You will need django to be installed in you computer to run this app. Head over to https://www.djangoproject.com/download/ for the download guide

Once you have downloaded django, go to the cloned repo directory and run the following command

```bash
$ python manage.py makemigrations
```

This will create all the migrations file (database migrations) required to run this App.

Now, to apply this migrations run the following command
```bash
$ python manage.py migrate
```

One last step and then our todo App will be live. We need to create an admin user to run this App. On the terminal, type the following command and provide username, password and email for the admin user
```bash
$ python manage.py createsuperuser
```

That was pretty simple, right? Now let's make the App live. We just need to start the server now and then we can start using our simple todo App. Start the server by following command

```bash
$ python manage.py runserver
```

Once the server is hosted, head over to http://127.0.0.1:8000/todos for the App.


# Deploy Todo-App on Kubernetes Cluster using Jenkins - DevOps Project!

### **Phase 1: Initial Setup and Deployment**

**Step 1: Launch EC2 (Ubuntu 22.04):**
NOTE: You can use local ubuntu machine created using virtualbox.

- Provision an EC2 instance on AWS with Ubuntu 22.04.
- Connect to the instance using SSH.

**Step 2: Clone the Code:**

- Update all the packages and then clone the code.
- Clone your application's code repository onto the EC2 instance:
    
    ```bash
    git clone https://github.com/Sakshi07-M/Devops-Python-Todo-App.git
    ```
    
**Step 3: Install Docker and Run the App Using a Container:**

- Set up Docker on the EC2 instance:
    
    ```bash
    
    sudo apt-get update
    sudo apt-get install docker.io -y
    sudo usermod -aG docker $USER  # Replace with your system's username, e.g., 'ubuntu'
    newgrp docker
    sudo chmod 777 /var/run/docker.sock
    ```
    
- Build and run your application using Docker containers:
    
    ```bash
    docker build -t sakshi0721/todo-app .
    docker run -d --name sakshi0721/todo-app -p 8081:80 sakshi0721/todo-app:latest
    
    #to delete
    docker stop <containerid>
    docker rmi -f sakshi0721/todo-app
    ```


### **Phase 2: Security**

1. **Install SonarQube and Trivy:**
    - Install SonarQube and Trivy on the EC2 instance to scan for vulnerabilities.
        
        sonarqube
        ```
        docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
        ```
        
        
        To access: 
        
        publicIP:9000 (by default username & password is admin)
        
        To install Trivy:
        ```
        sudo apt-get install wget apt-transport-https gnupg lsb-release
        wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
        echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
        sudo apt-get update
        sudo apt-get install trivy        
        ```
        
        to scan image using trivy
        ```
        trivy image <imageid>
        ```
        
### **Phase 3: CI/CD Setup**

1. **Install Jenkins for Automation:**
    - Install Jenkins on the EC2 instance to automate deployment:
    Install Java
    
    ```bash
    sudo apt update
    sudo apt install fontconfig openjdk-17-jre
    java -version
    openjdk version "17.0.8" 2023-07-18
    OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
    OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)
    
    #jenkins
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```
    
    - Access Jenkins in a web browser using the public IP of your EC2 instance.
        
        publicIp:8080


2. **Install Necessary Plugins in Jenkins:**

Goto Manage Jenkins →Plugins → Available Plugins →

Install below plugins

1 SonarQube Scanner (Install without restart)

2 Pipeline: Stage View Plugin

Configure Java in Global Tool Configuration

Goto Manage Jenkins → Tools → Install JDK(17) Click on Apply and Save


### SonarQube

Create the token

Goto Jenkins Dashboard → Manage Jenkins → Credentials → Add Secret Text. 

After adding sonar token

Click on Apply and Save

**The Configure System option** is used in Jenkins to configure different server

**Global Tool Configuration** is used to configure different tools that we install using Plugins

We will install a sonar scanner in the tools.


**Install Docker Tools and Docker Plugins:**

- Go to "Dashboard" in your Jenkins web interface.
- Navigate to "Manage Jenkins" → "Manage Plugins."
- Click on the "Available" tab and search for "Docker."
- Check the following Docker-related plugins:
  - Docker
  - Docker Commons
  - Docker Pipeline
  - Docker API
  - docker-build-step
- Click on the "Install without restart" button to install these plugins.

**Add DockerHub Credentials:**

- To securely handle DockerHub credentials in your Jenkins pipeline, follow these steps:
  - Go to "Dashboard" → "Manage Jenkins" → "Manage Credentials."
  - Click on "System" and then "Global credentials (unrestricted)."
  - Click on "Add Credentials" on the left side.
  - Choose "Secret text" as the kind of credentials.
  - Enter your DockerHub credentials (Username and Password) and give the credentials an ID (e.g., "docker").
  - Click "OK" to save your DockerHub credentials.
 
### **Phase 4: Kubernetes Setup**

1. **Create a minikube cluster:**
- Create a minikube cluster on local setup/AWS EC2 Instance:
- Install kubernetes-cli
  - After installation of minikube (For windows machine), open powershell and run command:
    ```bash
    minikube start
    ```
  - Run below command to check if minikube is up
    ```bash
    minikube status
    ```

3. **Install ArgoCD on minikube:**

Installation using kubernetes operators (Refer: )

- Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your cluster.
```bash
$ curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.30.0/install.sh | bash -s v0.30.0
```
Install the operator by running the following command
```bash
$ kubectl create -f https://operatorhub.io/install/argocd-operator.yaml
```

After install, watch your operator come up using next command.
```bash
$ kubectl get pods -n operators
```

Refer: https://argocd-operator.readthedocs.io/en/latest/usage/basics/
- Create argocd-basic.yaml file and add below content
```bash
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: example-argocd
  labels:
    example: basic
spec: {}
```
Check if argocd pods and service is up
```bash
  kubectl apply -f argocd-basic.yaml
  kubectl get pods
  kubectl get svc
```
Edit minikube svc to access it on browser
```bash
   kubectl edit svc example-argocd-server #Change ClusterIP to NodePort
   minikube service argocd-server
   minikube service list
```
Use URL generated from last command's output to access ArgoCD
e.g. http://192.168.59.102:31000/

3. **Create application on ArgoCD:**

- Click on application and create application
- Add all the required details and save the application
- Once saved, you will be able to see the deployment and services on argoCD UI, once CI/CD pipeline is triggered

### **Phase 4: Run CI/CD pipeline**

1. **Add Github Credentials:**

- To securely handle github credentials in your Jenkins pipeline, follow these steps:
  - Go to "Dashboard" → "Manage Jenkins" → "Manage Credentials."
  - Click on "System" and then "Global credentials (unrestricted)."
  - Click on "Add Credentials" on the left side.
  - Choose "Secret text" as the kind of credentials.
  - Enter your Github credentials (Username and Password) and give the credentials an ID (e.g., "github").
NOTE: Here passowrd will be token generated from github.
  - Click "OK" to save your github credentials.
    
2. **Configure CI/CD Pipeline in Jenkins:**
- Create a CI/CD pipeline in Jenkins to automate your application deployment.
- Select "Pipeline Script from SCM" and add your github repository details
- Click on Apply and Save
- Click on "Build Now" to trigger the pipeline

### **Phase 5: Deployment Verification**
- Check if manifest repo is updated with latest image tag in deployment.yaml file
- Open ArgoCD UI and verify if able to see deployment.
- Access UI and check if application is running.
