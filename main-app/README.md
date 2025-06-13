## 🚀 Deployment Instructions

1. **Clone the Application**  
   Clone the application you want to deploy into this directory.

2. **Update Configuration**  
   Modify the key values in the `application.properties` file to match your infrastructure (e.g., private DNS routes).

3. **Build the Artifact**  
   Run the following command to compile the project and generate the deployment artifact:
   ```bash
   mvn install
   ```

4. **Retrieve the Artifact**  
   After the build, get the generated artifact (usually a `.war` or `.jar`) from the `target/` directory.

5. **Upload to S3**  
   Use the AWS CLI to upload the artifact to your S3 bucket:
   ```bash
   aws s3 cp target/vprofile-v2.war s3://terraformstate9808/artifact/
   ```

6. **Deploy on EC2 Instance**
   - SSH into your `vprofile-app01` instance using its **private IP**:
     ```bash
     ssh -i <your-key.pem> ubuntu@<private-ip>
     ```
   - Run the following commands to deploy the artifact:
     ```bash
     sudo -i
     snap install aws-cli --classic
     aws s3 cp s3://terraformstate9808/artifact/vprofile-v2.war /tmp/

     systemctl stop tomcat10
     systemctl daemon-reload

     rm -rf /var/lib/tomcat10/webapps/ROOT
     cp /tmp/vprofile-v2.war /var/lib/tomcat10/webapps/ROOT.war

     systemctl start tomcat10
     ```
6. **Credentials for the app interface**
   user: admin_vp
   password: admin_vp